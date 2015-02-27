class AddCoReqToPrerequisites < ActiveRecord::Migration
  def change
    change_table :prerequisites do |t|
      t.boolean :co_req, default: false
    end
  end
end
