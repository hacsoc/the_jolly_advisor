class Course < ActiveRecord::Base
  has_many :course_instances

  scope :search, ->(q) { where("concat(lower(department), course_number) like ?
                               OR lower(title) like ?",
                               "%#{q.to_s.downcase.gsub(/\s+/,'')}%", "%#{q.to_s.downcase}%") }

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
