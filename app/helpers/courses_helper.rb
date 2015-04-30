module CoursesHelper
  def first_professor
    @course.course_instances.first.try(:professor) || Professor.TBA
  end

  def course_linkify(text)
    # "{2,}" says "at least two of".
    #
    # Hard code the link instead of using link_to, so that we can use the
    # capture groups from gsub.
    text.gsub(/([A-Z]{2,}) (\d{2,})/, '<a href="/courses/\1\2">\1 \2</a>').html_safe
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
