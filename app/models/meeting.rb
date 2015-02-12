class Meeting < ActiveRecord::Base
  belongs_to :course_instance
  belongs_to :professor
end
