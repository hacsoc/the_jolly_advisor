class RemoveProfessorsFromMeetings < ActiveRecord::Migration
  def up
    remove_column :meetings, :professor
  end

  def down
    add_column :meetings, :professor, :string
  end
end
