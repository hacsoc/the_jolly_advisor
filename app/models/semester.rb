class Semester < ActiveRecord::Base
  # This hash is to be used in the SchedulerController
  # It contains dates that are "guaranteed" to always
  # be within the given semester. There are dates for
  # both the first and second halves of semesters to
  # account for the half-semester gym classes.
  # When looking to show a schedule for a particular
  # semester, the scheduler can jump to one of these
  # dates. Just append the desired year, and use
  # the SAFE_JUMP_DATE_STRPTIME_STRING to get the DateTime
  # object (use DateTime so the timezone is consistent).
  SAFE_JUMP_DATES = {
    fall: {
      first: 'September 30',
      second: 'November 30'
    },
    spring: {
      first: 'February 01',
      second: 'April 01'
    },
    summer: {
      # TODO: uhhhhh
    }
  }.with_indifferent_access

  # Append to this with whatever format is approprite
  # for how you are specifying the year. Then call
  # DateTime.strptime on that.
  SAFE_JUMP_DATE_STRPTIME_STRING = '%B %d'

  def to_s
    "#{semester} #{year}"
  end
end
