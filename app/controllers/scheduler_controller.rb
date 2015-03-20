class SchedulerController < ApplicationController
  before_action :authenticate_user!
  before_action :set_scheduled_meetings, :if => :json_request?

  # GET /scheduler
  # GET /scheduler.json
  # GET /scheduler.js
  def index
  end

  private

  # Set the course instances to be rendered in the schedule
  # This is for the JSON feed that fullcalendar requires
  def set_scheduled_meetings
    if semester_request?
      set_timecop
    end
    # timecop should be set here to get the correct enrollments in the query
    meetings = current_user.enrolled_courses.ongoing.includes(:meetings, :course).flat_map(&:meetings)
    if semester_request?
      reset_timecop
    end
    # But timecop needs to be unset here to make sure the dates of the scheduled_meetings
    # are actually in the current week, which is what fullcalendar is expecting
    @scheduled_meetings = meetings.flat_map(&:scheduled_meetings)
  end

  def set_timecop
    jump_date_string = Semester::SAFE_JUMP_DATES[params[:semester][:semester].to_sym][params[:semester][:half].to_sym] + " #{params[:semester][:year]}"
    jump_date = DateTime.strptime(jump_date_string, Semester::SAFE_JUMP_DATE_STRPTIME_STRING + ' %Y')
    Timecop.travel(jump_date)
  end

  def reset_timecop
    Timecop.return
  end

  # move this to application controller eventually
  def json_request?
    request.format.json?
  end

  def semester_request?
    params.include? :semester
  end
end
