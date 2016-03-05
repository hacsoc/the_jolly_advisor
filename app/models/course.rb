class Course < ActiveRecord::Base
  has_many :course_instances, dependent: :destroy
  has_many :professors, through: :course_instances

  scope :search, ->(q) {
    where(%{concat(lower(courses.department), courses.course_number) like ?
           OR lower(courses.title) like ?},
          "%#{q.to_s.downcase.gsub(/\s+/, '')}%", "%#{q.to_s.downcase}%")
  }

  scope :order_by_short_name, -> { order(:department, :course_number) }

  def self.filter_by_name(name)
    return all unless name.present?
    search(name)
  end

  def self.filter_by_semester(semester)
    return all unless semester.present?
    joins(:course_instances)
      .where(course_instances: { semester_id: semester.to_i })
  end

  def self.filter_by_professor(professor)
    return all unless professor.present?
    joins(course_instances: :professor)
      .where(Professor.arel_table[:name].matches("%#{professor}%"))
  end

  def first_professor
    professors.order_by_realness.first || Professor.TBA
  end

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

  def schedulable?
    course_instances.any?(&:schedulable?)
  end

  def score(query)
    ("#{self} #{title}".downcase.split & query.downcase.split).length
  end

  def to_param
    "#{department}#{course_number}"
  end

  def to_s
    "#{department} #{course_number}"
  end

  def long_string
    "#{self}: #{title || 'Title Not Found'}"
  end
end
