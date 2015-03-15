class AddNotificationsToWishlistItems < ActiveRecord::Migration
  def change
    change_table :wishlist_items do |t|
      t.boolean :notify
    end
  end
end
