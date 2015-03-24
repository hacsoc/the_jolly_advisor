class User < ActiveRecord::Base
  has_many :wishlist, -> { includes :course }, class_name: 'WishlistItem'
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course_instance

  def to_s
    case_id
  end
end
