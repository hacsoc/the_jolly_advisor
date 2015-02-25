class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :case_id
      t.string :name
      t.string :type
      t.integer :class_year

      t.timestamps null: false
    end
    add_index :users, :case_id
  end
end
