class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department
      t.integer :course_number
      t.text :description
      t.string :course_offering

      t.timestamps null: false
    end
    add_index :courses, :department
    add_index :courses, :course_number
    add_index :courses, [:department, :course_number]
  end
end
