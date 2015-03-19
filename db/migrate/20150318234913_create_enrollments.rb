class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :user
      t.references :course_instance

      t.timestamps null: false
    end
  end
end
