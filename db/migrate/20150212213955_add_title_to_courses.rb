class AddTitleToCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.string :title
    end
  end
end
