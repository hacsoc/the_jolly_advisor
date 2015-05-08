class CreateReviewVotes < ActiveRecord::Migration
  def change
    create_table :review_votes do |t|
      t.references :user, index: true
      t.references :review, index: true
      t.integer :score

      t.timestamps null: false
    end
    add_foreign_key :review_votes, :users
    add_foreign_key :review_votes, :reviews

    reversible do |dir|
      dir.up do
        remove_index :reviews, :helpfulness
        remove_column :reviews, :helpfulness
      end

      dir.down do
        add_column :reviews, :helpfulness, :integer
        add_index :reviews, :helpfulness
      end
    end
  end
end
