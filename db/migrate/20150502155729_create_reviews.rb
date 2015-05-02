class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.references :course, index: true
      t.references :professor, index: true
      t.string :body
      t.integer :helpfulness

      t.timestamps null: false
    end
    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :courses
    add_foreign_key :reviews, :professors
    add_index :reviews, :helpfulness
  end
end
