class Course < ActiveRecord::Base
  has_many :course_instances

  def to_param
    "#{department}#{course_number}"
  end

  def to_s
    "#{department} #{course_number}"
  end
end
