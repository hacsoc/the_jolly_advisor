class CourseInstance < ActiveRecord::Base
  belongs_to :semester
  belongs_to :course
  belongs_to :professor
  has_many :meetings
  has_many :enrollments
  has_many :enrolled_students, through: :enrollments, source: :user

  scope :ongoing, -> { where('? BETWEEN start_date AND end_date', Date.today) }

  def schedulable?
    end_date > Date.today
  end
end
