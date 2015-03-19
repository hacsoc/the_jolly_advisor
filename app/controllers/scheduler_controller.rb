class SchedulerController < ApplicationController
  before_action :authenticate_user!
  before_action :set_scheduled_meetings, :if => :json_request?

  # GET /scheduler
  # GET /scheduler.json
  def index
  end

  private

  # Set the course instances to be rendered in the schedule
  # This is for the JSON feed that fullcalendar requires
  def set_scheduled_meetings
    @scheduled_meetings = current_user.enrolled_courses.ongoing.includes(:meetings).flat_map(&:meetings).flat_map(&:scheduled_meetings)
  end

  # move this to application controller eventually
  def json_request?
    request.format.json?
  end
end
