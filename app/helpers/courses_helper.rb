module CoursesHelper
  def first_professor
    @course.course_instances.first.professor
  end

  def prereq_sets(course)
    prereq_sets = course.prerequisites
    if prereq_sets.empty?
      ['None']
    else
      prereq_sets.map do |prereq_set|
        prereq_set.map { |prereq| link_to(prereq, prereq.to_param) }.join(" or ").html_safe
      end
    end
  end

  def postreqs(course)
    postreqs = course.postrequisites
    if postreqs.empty?
      ['None']
    else
      postreqs.map { |postreq| link_to(postreq, postreq.to_param) }
    end
  end
end
