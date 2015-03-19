class SchedulerController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course_instances, :if => :json_request?

  # GET /scheduler
  # GET /scheduler.json
  def index
  end

  private

  # Set the course instances to be rendered in the schedule
  # This is for the JSON feed that fullcalendar requires
  def set_course_instances
    @course_instances = current_user.enrolled_courses.ongoing.includes(:meetings)
  end

  # move this to application controller eventually
  def json_request?
    request.format.json?
  end
end
