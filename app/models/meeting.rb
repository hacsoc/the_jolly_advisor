class Meeting < ActiveRecord::Base
  belongs_to :course_instance
  belongs_to :professor

  MEETING_TIME_REGEX = /\d{1,2}:\d{1,2} [AP]M/

  # Return an Array of ScheduledMeetings for this Meeting.
  # Empty if the schedule is TBA
  # 
  # All schedules have the form:
  #   DAY_ABBRVS START_TIME - END_TIME
  def scheduled_meetings
    return [] if schedule == 'TBA'

    # the start time is the first time in the schedule
    start_time = schedule.match(/^.* (#{MEETING_TIME_REGEX}) - #{MEETING_TIME_REGEX}$/).captures.first
    # the end time is the second time
    end_time = schedule.match(/^.* #{MEETING_TIME_REGEX} - (#{MEETING_TIME_REGEX})$/).captures.first
    # To get the day abbreviations, only look at the schedule up to the first space.
    # Then, for each abbreviation, create a ScheduledMeeting for that day
    schedule[0..schedule.index(' ')].scan(/[A-Z][a-z]?/) # MTuWThFSaSu
                                    .map { |day_abbreviation| ScheduledMeeting.new day_abbreviation, start_time, end_time, self }
  end
end

