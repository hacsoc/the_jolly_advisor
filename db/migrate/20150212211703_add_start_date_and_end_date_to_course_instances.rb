class AddStartDateAndEndDateToCourseInstances < ActiveRecord::Migration
  def change
    change_table :course_instances do |t|
      t.date :start_date
      t.date :end_date
    end
  end
end
