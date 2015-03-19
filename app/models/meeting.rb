class Meeting < ActiveRecord::Base
  belongs_to :course_instance
  belongs_to :professor

  MEETING_TIME_REGEX = /\d{1,2}:\d{1,2} [AP]M/

  def scheduled_meetings
    return [] if schedule == 'TBA'

    start_time = schedule.match(/^.* (#{MEETING_TIME_REGEX}) - #{MEETING_TIME_REGEX}$/).captures.first
    end_time = schedule.match(/^.* #{MEETING_TIME_REGEX} - (#{MEETING_TIME_REGEX})$/).captures.first
    schedule[0..schedule.index(' ')].scan(/[A-Z][a-z]?/) # MTuWThFSaSu
                                    .map { |day_abbreviation| ScheduledMeeting.new day_abbreviation, start_time, end_time, self }
  end
end

