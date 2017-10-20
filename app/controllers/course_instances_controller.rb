class CourseInstancesController < ApplicationController
  before_action :set_search_date, only: [:autocomplete], :if => -> { params[:semester] }

  # GET /course_instances/autocomplete.json
  def autocomplete
    @course_instances = CourseInstance.search(
      params[:term],
      current_user,
      params[:current_date] || @search_date,
    ).includes(:meetings)

    respond_to do |format|
      format.json do
        render json: (@course_instances.flat_map(&:meetings).map do |m|
          {
            label: m.autocomplete_label,
            value: m.autocomplete_label,
            id: m.course_instance_id,
          }
        end)
      end
    end
  end
end
