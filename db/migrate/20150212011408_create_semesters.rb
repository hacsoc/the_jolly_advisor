class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :year
      t.string :semester
      t.boolean :finished
    end
  end
end
