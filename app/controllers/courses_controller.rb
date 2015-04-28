class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @semesters = Semester.all
    @courses = Course.all
    if params[:search].present?
      @courses = @courses.search(params[:search])
    end
    if params[:semester].present?
      @courses = @courses.joins(:course_instances).where(course_instances: { semester_id: params[:semester].to_i })
    end
    if params[:professor].present?
      professor = Professor.arel_table
      @courses = @courses.joins(course_instances: :professor).where(professor[:name].matches("%#{params[:professor]}%"))
    end
    course_ids = @courses.pluck('courses.id').uniq
    @courses = Course.where('id IN (?)', course_ids).dept_order
    @courses = @courses.page(params[:page])
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @instances_by_semester = @course.course_instances.includes(:semester).group_by(&:semester)
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @courses = Course.search(params[:term])
    respond_to do |format|
      format.json { render json: @courses.map{ |c| { id: c.id, label: c.long_string, value: c.to_param } } }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    department, course_number = params[:id].match(/([a-zA-Z]+)(\d+)/).captures.map(&:upcase)
    @course = Course.find_by(department: department, course_number: course_number) or not_found
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:department, :course_number, :description, :course_offering)
  end
end
