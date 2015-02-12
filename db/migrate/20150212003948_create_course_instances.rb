class CreateCourseInstances < ActiveRecord::Migration
  def change
    create_table :course_instances do |t|
      t.references :semester, index: true
      t.references :course, index: true
      t.references :professor, index: true
      t.json :schedule

      t.timestamps null: false
    end
    add_foreign_key :course_instances, :semesters
    add_foreign_key :course_instances, :courses
    add_foreign_key :course_instances, :professors
  end
end
