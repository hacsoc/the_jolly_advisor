class CreatePrerequisites < ActiveRecord::Migration
  def change
    create_table :prerequisites, id: false do |t|
      t.references :prerequisite, null: false
      t.references :postrequisite, null: false
    end
  end
end
