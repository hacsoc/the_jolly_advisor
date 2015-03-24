class CourseInstancesController < ApplicationController
  # GET /course_instances/autocomplete.json
  def autocomplete
    @course_instances = CourseInstance.search(params[:term], current_user, params[:current_date]).includes(:meetings)
    respond_to do |format|
      format.json do
        render json: (@course_instances.flat_map(&:meetings).map do |m|
          {
            # call .strip on the schedule because some of the imported
            # data from SIS has trailing whitespace
            label: "#{m.course_instance.course.long_string} (#{m.schedule.strip || 'TBA'})",
            value: m.course_instance_id
          }
        end)
      end
    end
  end
end
