class CourseInstance < ActiveRecord::Base
  belongs_to :semester
  belongs_to :course
  belongs_to :professor
end
