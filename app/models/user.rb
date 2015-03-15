class User < ActiveRecord::Base
  def to_s
    case_id
  end

  def wishlist
    WishlistItem.includes(:course).where(user_id: id)
  end
end
