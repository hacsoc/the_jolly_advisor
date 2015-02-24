class AddSubtitleToCourseInstances < ActiveRecord::Migration
  def change
    change_table :course_instances do |t|
      t.string :subtitle
    end
  end
end
