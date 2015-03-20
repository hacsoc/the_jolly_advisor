class CourseInstance < ActiveRecord::Base
  belongs_to :semester
  belongs_to :course
  belongs_to :professor
  has_many :meetings
  has_many :enrollments
  has_many :enrolled_students, through: :enrollments, source: :user

  scope :ongoing, ->(date = Date.today) { where('? BETWEEN course_instances.start_date AND course_instances.end_date', date) }
  scope :search, ->(term, date = Date.today) {
    includes(:course, :meetings)
    .ongoing(date)
    .joins(:course)
    .where(%{concat(lower(courses.department), courses.course_number) like ?
            OR lower(courses.title) like ?},
            "%#{term.to_s.downcase.gsub(/\s+/,'')}%", "%#{term.to_s.downcase}%")
  }

  def schedulable?
    end_date > Date.today
  end
end
