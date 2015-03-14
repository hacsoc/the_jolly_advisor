class User < ActiveRecord::Base
  def to_s
    case_id
  end

  def wishlist
    WishlistItem.includes(:courses).where(user_id: id).map(&:course)
  end
end
