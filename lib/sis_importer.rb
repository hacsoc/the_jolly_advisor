require 'nokogiri'
require 'open-uri'


module SISImporter
  class << self
    def fetch_terms
      sis_dump_url = "http://case.edu/projects/erpextract/soc.xml"
      doc = Nokogiri::XML(open(sis_dump_url))
      return doc.xpath('//Terms/Term')
    end

    def import_sis
      terms = fetch_terms
      terms.each do |term|
        semester_term, semester_year = term.xpath('Descr').text.split
        semester = Semester.where(semester: semester_term, year: semester_year).first_or_create
        p semester
        courses = term.xpath('Classes/Class')
        courses.each do |c|
          subject = c.xpath('Subject').text
          number = c.xpath('CatalogNbr').text
          title = c.xpath('CourseTitleLong').text
          description = c.xpath('Description').text
          units = c.xpath('UnitsMin').text #TODO: Should this be min or max, or something else?
          dates = c.xpath('Dates').text
          start_date, end_date = dates.split(/\s-\s/).map{|d| Date.strptime(d, '%m/%d/%Y')}
          meetings = c.xpath('Meetings/Meeting')
          course = Course.where(department: subject, course_number: number).first_or_initialize
          course.description = description
          course.title = title
          course.save
          p course
          #TODO: course.course_offering = do something
          
          #TODO: We need some code for multiple sections
          #TODO: We need some stuff for professor of class (Hard because there can be multiple)
          course_instance = CourseInstance.where(semester: semester, course: course).first_or_initialize
          course_instance.update_attributes(start_date: start_date, end_date: end_date)
          course_instance.save
          p course_instance
          meetings.each do |meeting|
            m_schedule = meeting.xpath('DaysTimes').text #TODO: json?
            m_room = meeting.xpath('Room').text
            m_prof = Professor.where(name: meeting.xpath('Instructor').text).first_or_create
            p m_prof
            m_dates = meeting.xpath('MeetingDates').text
            m_start_date, m_end_date = m_dates.split(/\s-\s/).map{|d| Date.strptime(d, '%m/%d/%Y')}
            meeting = Meeting.where(schedule: m_schedule, room: m_room, professor: m_prof, course_instance: course_instance,
                                    start_date: m_start_date, end_date: m_end_date).first_or_create
            p meeting
          end
        end
      end
    end
  end
end
