class AddComponentCodeToCourseInstances < ActiveRecord::Migration
  def change
    change_table :course_instances do |t|
      t.string :component_code
    end
  end
end
