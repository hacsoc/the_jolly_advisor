require 'smarter_csv'

# Module to get course data from CSV files obtained from SIS.
# Call CSVImporter.import_csv to get started. Currently needs
# a file and a Semster object to do its thing.
module CSVImporter
  class CourseData
    attr_reader :department, :course_number, :title, :section,
                :component_code, :schedule, :room, :professor,
                :start_date, :end_date
    # Initialize a CourseData object based on a hash of attributes.
    # The attributes hash corresponds to a row from the csv file.
    # Does some post-processing on the data to extract the info
    # we really care about.
    # This code isn't very clean, so if someone comes up with a
    # good way to refactor it, that would be awesome.
    def initialize(attributes)
      course_dept_number, @title = attributes[:description].split(/\s-\s/)
      @department, @course_number = /([A-Z]+)\s([0-9]+)/.match(course_dept_number).captures

      @section, component_info = /([0-9]+)-(.*)/.match(attributes[:section]).captures
      @component_code = /([A-Z]+).*/.match(component_info).captures.first

      @schedule = attributes[:days_and_times]

      # If the string doesn't match, then it's usually
      # "To Be Announced" or "To Be Scheduled", so just use that.
      @room = /(.*)\s\(.*\)/.match(attributes[:room_and_capacity])
                            .try(:captures)
                            .try(:first) || attributes[:room_and_capacity]

      @professor = attributes[:instructor]

      @start_date, @end_date = attributes[:meeting_dates].split(/\s-\s/)

      typecast!
    end

    private

    # The code in #initialize leaves everything as strings.
    # This takes care of some typecasting
    def typecast!
      [:course_number, :section].each do |attr|
        instance_variable_set("@#{attr}", send(attr).to_i)
      end

      [:start_date, :end_date].each do |attr|
        instance_variable_set("@#{attr}", Date.strptime(public_send(attr), '%m/%d/%y'))
      end
    end
  end

  class << self
    # Import a CSV file from SIS for a given semester
    # and update the database with the data
    def import_csv(csv, semester)
      SmarterCSV.process(csv, key_mapping: sis_csv_key_mapping) do |rows|
        rows.each { |row_hash| update_db CourseData.new(row_hash), semester }
      end
    end

    private

    # Update the database with the information contained in course_data
    # for the given semester (needed for course_instance updates)
    def update_db(course_data, semester)
      update_meetings(
        update_course_instance(
          update_course(course_data),
          semester,
          course_data,
        ),
        course_data,
      )
    end

    # Update the course based on course_data and return the resulting course
    def update_course(course_data)
      course = Course.where(
        department: course_data.department,
        course_number: course_data.course_number,
      ).first_or_initialize
      course.update_attributes(title: course_data.title)
      course
    end

    # Update the course_instance based on course and course_date for the given semester, and
    # return the resulting course_data
    def update_course_instance(course, semester, course_data)
      course_instance = CourseInstance.where(
        course: course,
        semester: semester,
        section: course_data.section,
      ).first_or_initialize
      course_instance.update_attributes(
        professor: Professor.where(
          name: course_data.professor,
        ).first_or_create,
        component_code: course_data.component_code,
        start_date: course_data.start_date,
        end_date: course_data.end_date,
      )
      course_instance
    end

    # Update the meetings of the given course_instance based on course_data
    def update_meetings(course_instance, course_data)
      course_instance
        .meetings
        .where(
          course_instance: course_instance,
          professor: course_instance.professor,
          schedule: course_data.schedule,
        ).first_or_initialize
        .update_attributes(
          room: course_data.room,
          start_date: course_data.start_date,
          end_date: course_data.end_date,
        )
    end

    # Provide some better key mappings for some of the awful column
    # names that SIS gives us
    def sis_csv_key_mapping
      {
        :"days_&_times"              => :days_and_times,
        :"room_(capacity)"           => :room_and_capacity,
        :"enrl_cap_(cmbnd_enrl_cap)" => :enrollment_cap,
        :"enrl_tot_(cmbnd_enrl_tot)" => :onrollment_total,
      }
    end
  end
end
