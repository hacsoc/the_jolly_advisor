class CourseQuery < SimpleDelegator
  def score(query)
    ("#{self} #{title}".downcase.split & query.downcase.split).length
  end
end
