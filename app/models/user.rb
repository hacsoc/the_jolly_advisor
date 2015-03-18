class User < ActiveRecord::Base
  has_many :wishlist, -> { includes :course }, class_name: 'WishlistItem'

  def to_s
    case_id
  end
end
