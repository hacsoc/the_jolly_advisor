require 'nokogiri'
require 'open-uri'

# I've re-written this module to be much more functional.
# The only publicly accessible method is now #import_sis
# All other methods are now private.

# Helper methods can be split into 2 categories based on
# the prefix of the method name. Methods that begin with
# fetch_* handle pulling information out of the XML doc
# and involve a lot of calls to #xpath. Methods that begin
# with process_* handle persisting the data retrieved by the
# fetch_* methods to the database and involve a lot of calls
# to ActiveRecord.

module SISImporter
  using PGArrayPatch

  class << self
    def import_sis
      fetch_terms.each { |term_xml| process_term(term_xml, fetch_term_info(term_xml)) } 
    end

    # term_info is an array of two values, the first being the semester and
    # the second being the year.
    def process_term(term_xml, term_info)
      process_semester(term_xml, Semester.where(semester: term_info[0], year: term_info[1]).first_or_create)
    end
    
    def process_semester(term_xml, semester)
      fetch_classes(term_xml).each { |class_xml| process_course(class_xml, semester, fetch_course_attributes(class_xml)) }
    end

    def process_course(class_xml, semester, course_attributes)
      # Cache the course for database perf
      course = Course.where(department: course_attributes[:subject], course_number: course_attributes[:number]).first_or_initialize
      # Rails is smart and inserts a new row when you call #update_attributes
      # if the record doesn't exist yet, so calling #save is redundant
      course.update_attributes(description: course_attributes[:description], title: course_attributes[:title])

      process_prerequisites(course, course_attributes[:enrollment_req_info]) if course_attributes[:enrollment_req_info] != '' # not every course has this attribute
      # TODO: course.course_offering = do something
      # TODO: We need some stuff for professor of class (Hard because there can be multiple)
      process_course_instance(class_xml,
                              CourseInstance.where(semester: semester,
                                                   course: course,
                                                   section: course_attributes[:section],
                                                   subtitle: course_attributes[:subtitle]).first_or_initialize,
                              course_attributes)
    end

    def process_course_instance(class_xml, course_instance, course_attributes)
      course_instance.update_attributes(start_date: course_attributes[:dates][0],
                                        end_date: course_attributes[:dates][1],
                                        component_code: course_attributes[:component_code])

      fetch_meetings(class_xml).each { |meeting_xml| process_meeting(meeting_xml, course_instance, fetch_meeting_attributes(meeting_xml)) }

      course_instance.update_attributes(professor: course_instance.meetings.first.try(:professor) || Professor.TBA)
    end

    def process_professor(prof_name)
      Professor.where(name: prof_name).first_or_create
    end

    def process_meeting(class_xml, course_instance, meeting_attributes)
      Meeting.where(schedule: meeting_attributes[:schedule], room: meeting_attributes[:room],
                    professor: meeting_attributes[:prof], course_instance: course_instance,
                    start_date: meeting_attributes[:dates][0], end_date: meeting_attributes[:dates][1]).first_or_create
    end

    def process_prerequisites(course, enrollment_req_info)
      fetch_reqs(enrollment_req_info).each do |req|
        # Build up a list of lists of course ids of the prereqs
        course_id_sets = req[:reqs].map do |clause|
          clause.map do |long_title|
            department, course_number = long_title.split
            Course.where(department: department, course_number: course_number)
                  .first_or_create
                  .id
          end
        end

        # for each set of prereq ids, create a row
        course_id_sets.each do |course_id_set|
          Prerequisite.where(postrequisite: course,
                             prerequisite_ids: course_id_set.to_pg_sql,
                             co_req: req[:co_req])
                      .first_or_create
        end
      end
    end

    def fetch_terms
      Nokogiri::XML(open("http://case.edu/projects/erpextract/soc.xml")).xpath('//Terms/Term')
    end
    
    def fetch_classes(term_xml)
      term_xml.xpath('Classes/Class') 
    end

    def fetch_meetings(class_xml)
      class_xml.xpath('Meetings/Meeting')
    end

    def fetch_term_info(term_xml)
      term_xml.xpath('Descr').text.split.map(&:strip)
    end

    def fetch_course_attributes(class_xml)
      {
        subject:             class_xml.xpath('Subject').text.strip,
        number:              class_xml.xpath('CatalogNbr').text.strip,
        description:         class_xml.xpath('Description').text.strip,
        units:               class_xml.xpath('UnitsMin').text.strip, #TODO: Should this be min, max, or something else?
        dates:               fetch_start_end_dates(class_xml.xpath('Dates').text.strip),
        section:             class_xml.xpath('Section').text.strip,
        component_code:      class_xml.xpath('ComponentCode').text.strip,
        enrollment_req_info: class_xml.xpath('EnrollmentRequirements').text.strip
      }.merge(fetch_title_and_subtitle(class_xml.xpath('CourseTitleLong').text.strip))
    end

    def fetch_title_and_subtitle(full_title)
      # Special handling for Special Topics courses
      if full_title.start_with? 'Special Topics'
        {
          title:    'Special Topics',
          subtitle: full_title[/Special Topics: (.*)/, 1]
        }
      else
        {
          title:    full_title,
          subtitle: nil
        }
      end
    end

    def fetch_reqs(enrollment_req_info)
      # Not sure if there's a class that has only co-reqs, so this is probably safe.
      index = enrollment_req_info.index 'Coreq:'
      # if the string contains 'Coreq:', then parse from 'Coreq:' on as coreqs
      # and then parse from the beginning up to 'Coreq:' (or end of string) as prereqs
      temp = index ?
        [parse_reqs(enrollment_req_info[index..-1])] :
        []

      ->(str) {
        # Make sure the string has at least one thing to match
        str.include?(':') && str.match(/.*\b[A-Z]+ \d+.*/) ?
          temp << parse_reqs(str) :
          temp
      }.(enrollment_req_info[0..(index || -1)])
    end

    # Return hash for the reqs in string. Two keys,
    # one for if this is a coreq or not, the other for
    # the list of lists of course long_titles (DEPT COURSE_NUM)
    def parse_reqs(str)
      {
        co_req: str.start_with?('Coreq'),
        reqs:   parse_reqs_helper(str[(str.index(':') + 1)..-1])
      }
    end

    def parse_reqs_helper(reqs)
      req_info = [[]]
      req_matches = reqs.scan(/([A-Z]+ \d+)/)
      req_matches.each_with_index do |match_arr, index|
        match = match_arr[0]
        req_info.last << match and break if index == (req_matches.count - 1)

        str_between_start = reqs.index(match) + match.length
        str_between_end = reqs.index(req_matches[index + 1][0])
        str_between = reqs[str_between_start..str_between_end]

        # Assumption: if the string between two matches contains 'or',
        # then it is an OR relationship between the current set of
        # courses and the current match. If the string does not, then
        # assume it is an AND relationship between the current set of
        # courses and the next set.
        if str_between.include? ' or '
          req_info.last << match
        else
          # AND case. start a new subarray
          req_info.last << match
          req_info << []
        end
      end
      req_info
    end

    def fetch_meeting_attributes(meeting_xml)
      {
        schedule: meeting_xml.xpath('DaysTimes').text.strip,
        room: meeting_xml.xpath('Room').text.strip,
        prof: process_professor(meeting_xml.xpath('Instructor').text.strip),
        dates: fetch_start_end_dates(meeting_xml.xpath('MeetingDates').text.strip)
      }
    end

    def fetch_start_end_dates(dates)
      dates.split(/\s-\s/).map { |d| Date.strptime(d, '%m/%d/%Y') }
    end
  end
end
