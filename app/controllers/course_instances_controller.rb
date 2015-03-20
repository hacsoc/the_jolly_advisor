class CourseInstancesController < ApplicationController
  # GET /course_instances/autocomplete.json
  def autocomplete
    @course_instances = CourseInstance.search(params[:term], current_user, params[:current_date])
    respond_to do |format|
      format.json do
        render json: (@course_instances.map do |ci|
          {
            label: "#{ci.course.long_string} (#{ci.meetings.first.try(:schedule) || 'TBA'})",
            value: ci.id
          }
        end)
      end
    end
  end
end
