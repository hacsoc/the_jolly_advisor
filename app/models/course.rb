class Course < ActiveRecord::Base
  has_many :course_instances, dependent: :destroy
  has_many :professors, through: :course_instances
  has_many :reviews, dependent: :destroy

  scope :search, ->(q) {
    where(%{concat(lower(courses.department), courses.course_number) like ?
           OR lower(courses.title) like ?},
          "%#{q.to_s.downcase.gsub(/\s+/, '')}%", "%#{q.to_s.downcase}%")
  }

  scope :order_by_short_name, -> { order(:department, :course_number) }

  # Get all prereq info from the database.
  # Return an array of arrays of courses.
  def prerequisites
    Prerequisite.where(postrequisite: self).map do |prereq|
      Course.where(id: prereq.prerequisite_ids)
    end
  end

  def postrequisites
    Course.where(id: Prerequisite.where('? = ANY(prerequisite_ids)', id).pluck(:postrequisite_id))
  end

  def real_professors
    professors.find_all { |p| !['Staff', 'TBA'].include?(p.name) }
  end

  def schedulable?
    course_instances.any? { |course_instance| course_instance.try(:schedulable?) }
  end

  def to_param
    "#{department}#{course_number}"
  end

  def to_s
    "#{department} #{course_number}"
  end

  def long_string
    "#{self}: #{title}"
  end
end
