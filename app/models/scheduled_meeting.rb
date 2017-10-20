# For use with the SchedulerController.
#
# CourseInstances have Meetings which have a
# schedule attribute like 'MWF 10:00 AM - 10:50 AM'
#
# This class represents an actual scheduled meeting
# for a meeting. So, for the above example schedule,
# the meeting would have three ScheduledMeetings,
# one for Monday, one for Wednesday, and one for Friday,
# each from 10 AM to 10:50 AM.
class ScheduledMeeting
  attr_reader :meeting, :start_time, :end_time

  # Map the day abbreviations that SIS used to
  # the symbols used by the Ruby Date/Time classes
  DAY_ABBRV_HASH = {
    'M' => :monday,
    'Tu' => :tuesday,
    'W' => :wednesday,
    'Th' => :thursday,
    'F' => :friday,
    'Sa' => :saturday,
    'Su' => :sunday,
  }.freeze

  def initialize(day_abbreviation, time_range, meeting)
    # Hold on to the meeting so that we can reference things about it
    # (course, professor, etc) in the calendar (see app/views/scheduler/index.json.jbuilder)
    @meeting = meeting

    day_sym = DAY_ABBRV_HASH[day_abbreviation]
    # Always jump to the beginning of the week, then advance by the appropriate
    # number of days. This ensures that @start_time and @end_time are always within
    # the range of the current week.
    # Additionally, using DateTime#at_beginning_of_week always sets the time
    # portion of the DateTime to midnight (that is when the week technically begins after all)
    # so this guarantee allows the advance function (see below) to work they way it does.
    date = DateTime.now.at_beginning_of_week +
           DateTime::DAYS_INTO_WEEK[day_sym].days

    @start_time = advance(date, time_range.begin)
    @end_time = advance(date, time_range.end)
  end

  private

  # Advance a DateTime object by a Time object
  #
  # This works because the DateTime object always has
  # a time of midnight
  def advance(date, time)
    date.advance(hours: time.hour, minutes: time.min, seconds: time.sec)
  end
end
