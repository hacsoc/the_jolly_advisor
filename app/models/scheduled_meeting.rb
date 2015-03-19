class ScheduledMeeting
  attr_reader :meeting, :start_time, :end_time

  DAY_ABBRV_HASH = {
    'M' => :monday,
    'Tu' => :tuesday,
    'W' => :wednesday,
    'Th' => :thursday,
    'F' => :friday,
    'Sa' => :saturday,
    'Su' => :sunday
  }

  TIME_FORMAT = '%l:%M %p'

  def initialize(day_abbreviation, start_string, end_string, meeting)
    @meeting = meeting

    day_sym = DAY_ABBRV_HASH[day_abbreviation]
    date = DateTime.now.at_beginning_of_week +
      DateTime::DAYS_INTO_WEEK[day_sym].days

    start_time = Time.strptime(start_string, TIME_FORMAT)
    end_time = Time.strptime(end_string, TIME_FORMAT)

    @start_time = advance(date, start_time)
    @end_time = advance(date, end_time)
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
