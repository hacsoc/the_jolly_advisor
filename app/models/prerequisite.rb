class Prerequisite < ActiveRecord::Base
  belongs_to :postrequisite, class_name: 'Course'
end
