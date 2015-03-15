class WishlistController < ApplicationController
  before_action :authenticate_user!

  # GET /wishlist
  def index
    @wishlist = current_user.wishlist
  end

  # POST /wishlist
  def add_course
    @wishlist_item = WishlistItem.where(user: current_user, course_id: params[:course_id])
                                 .first_or_initialize
    respond_to do |format|
      if @wishlist_item.save
        flash[:notice] = 'Course successfully saved to your wishlist'
        format.html { redirect_to params[:url] || wishlist_path }
      else
        flash[:notice] = 'An error occurred adding the course to your wishlist'
        format.html { redirect_to params[:url] || wishlist_path }
      end
    end
  end
end
