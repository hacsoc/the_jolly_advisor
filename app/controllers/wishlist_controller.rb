class WishlistController < ApplicationController
  before_action :authenticate_user!

  # GET /wishlist
  def index
    @wishlist = current_user.wishlist
  end
end
