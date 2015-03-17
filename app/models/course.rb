class Course < ActiveRecord::Base
  has_many :course_instances

  scope :search, ->(q) { where("concat(lower(department), course_number) like ?
                               OR lower(title) like ?",
                               "%#{q.to_s.downcase.gsub(/\s+/,'')}%", "%#{q.to_s.downcase}%") }

  # Get all prereq info from the database.
  # Return an array of arrays of courses.
  def prerequisites
    Prerequisite.where(postrequisite: self).map do |prereq|
      Course.where(id: prereq.prerequisite_ids)
    end
  end

  def postrequisites
    Prerequisite.where('? = ANY(prerequisite_ids)', self.id).map do |prereq|
      Course.find_by(id: prereq.postrequisite_id)
    end
  end

  # Is this course currently schedulable?
  def schedulable?
    !course_instances.to_a.keep_if { |instance| instance.schedulable? }.empty?
  end

  def to_param
    "#{department}#{course_number}"
  end

  def to_s
    "#{department} #{course_number}"
  end

  def long_string
    "#{to_s}: #{title}"
  end
end
