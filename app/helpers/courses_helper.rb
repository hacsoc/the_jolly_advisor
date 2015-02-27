module CoursesHelper
  def first_professor
    @course.course_instances.first.professor
  end
end
