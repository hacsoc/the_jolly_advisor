require 'course_query'

class CoursesController < ApplicationController
  before_action :set_course, only: [:show]

  # GET /courses
  # GET /courses.json
  def index
    @semesters = Semester.all
    @courses =
      Course.filter_by_name(params[:search])
            .filter_by_semester(params[:semester])
            .filter_by_professor(params[:professor])
            .order_by_short_name
            .distinct
    @courses = @courses.page(params[:page])
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @instances_by_semester = @course.course_instances.includes(:semester).group_by(&:semester)
  end

  def autocomplete
    @courses =
      Course.search(params[:term])
            .sort_by { |course| -CourseQuery.new(course).score(params[:term]) }
    respond_to do |format|
      format.json do
        render json: @courses.map { |c| {id: c.id, label: c.long_string, value: c.to_param} }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    department, course_number = params[:id].match(/([a-zA-Z]+)(\d+)/).captures.map(&:upcase)
    @course = Course.find_by(department: department, course_number: course_number)

    @course ? @course : not_found
  end
end
