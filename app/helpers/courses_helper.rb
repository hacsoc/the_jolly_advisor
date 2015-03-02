module CoursesHelper
  def first_professor
    @course.course_instances.first.professor
  end

  def prereq_sets(course)
    prereq_sets = course.prerequisites
    if prereq_sets.empty?
      [content_tag(:li, 'None')]
    else
      prereq_sets.map do |prereq_set|
        content_tag :li do
          concat prereq_set.map { |prereq| content_tag(:a, prereq.to_s, href: prereq.to_param).to_s }.join(" or ")
        end
      end
    end
  end
end
