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
  class << self
    def import_sis
      fetch_terms.each { |term_xml| process_term(term_xml, fetch_term_info(term_xml)) } 
    end

    private

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
      #TODO: course.course_offering = do something
      #TODO: We need some stuff for professor of class (Hard because there can be multiple)
      process_course_instance(class_xml,
                              CourseInstance.where(semester: semester, course: course, section: course_attributes[:section]).first_or_initialize,
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
      term_xml.xpath('Descr').text.split
    end

    def fetch_course_attributes(class_xml)
      {
        subject:        class_xml.xpath('Subject').text,
        number:         class_xml.xpath('CatalogNbr').text,
        title:          class_xml.xpath('CourseTitleLong').text,
        description:    class_xml.xpath('Description').text,
        units:          class_xml.xpath('UnitsMin').text, #TODO: Should this be min or max, or something else?
        dates:          fetch_start_end_dates(class_xml.xpath('Dates').text),
        section:        class_xml.xpath('Section').text,
        component_code: class_xml.xpath('ComponentCode').text
      }
    end

    def fetch_meeting_attributes(meeting_xml)
      {
        schedule: meeting_xml.xpath('DaysTimes').text, #TODO: json?
        room: meeting_xml.xpath('Room').text,
        prof: process_professor(meeting_xml.xpath('Instructor').text),
        dates: fetch_start_end_dates(meeting_xml.xpath('MeetingDates').text)
      }
    end
    
    def fetch_start_end_dates(dates)
      dates.split(/\s-\s/).map{ |d| Date.strptime(d, '%m/%d/%Y') }
    end
  end
end
