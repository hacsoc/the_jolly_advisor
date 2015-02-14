class AddSectionToCourseInstances < ActiveRecord::Migration
  def change
    change_table :course_instances do |t|
      t.integer :section
    end
  end
end
