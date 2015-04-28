class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course_instance

  validates :course_instance_id, :user_id, presence: true
end
