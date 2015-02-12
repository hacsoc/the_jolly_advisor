class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.references :course_instance, index: true
      t.references :professor, index: true
      t.string :schedule # TODO: Fix this
      t.string :room
      t.string :professor
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
    add_foreign_key :meetings, :course_instances
    add_foreign_key :meetings, :professors
  end
end
