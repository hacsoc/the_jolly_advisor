class Meeting < ActiveRecord::Base
  belongs_to :course_instance
  belongs_to :professor

  TIME_REGEX = /\d{1,2}:\d{1,2} [AP]M/
  MEETING_SCHEDULE_REGEX = /^(.*) (#{TIME_REGEX}) - (#{TIME_REGEX})/

  def autocomplete_label
    "#{course_instance.course.long_string} (#{schedule || 'TBA'})"
  end

  # Return an Array of ScheduledMeetings for this Meeting.
  # Empty if the schedule is TBA
  #
  # All schedules have the form:
  #   DAY_ABBRVS START_TIME - END_TIME
  def scheduled_meetings
    return [] if schedule.start_with?('TBA') # sometimes there's trailing whitespace

    abbreviations, start_time, end_time = schedule.match(MEETING_SCHEDULE_REGEX).captures
    # For each abbreviation, create a ScheduledMeeting for that day
    abbreviations
      .scan(/[A-Z][a-z]?/) # MTuWThFSaSu
      .map { |day_abbreviation| ScheduledMeeting.new day_abbreviation, start_time, end_time, self }
  end
end
