class ChangePrequisiteIdToArrayOnPrequisites < ActiveRecord::Migration
  def up
    change_table :prerequisites do |t|
      t.remove :prerequisite_id
      t.integer :prerequisite_ids, array: true, default: []
    end
  end

  def down
    change_table :prerequisites do |t|
      t.remove :prerequisite_ids
      t.references :prerequisite, null: false
    end
  end
end
