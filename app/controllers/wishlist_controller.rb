class WishlistController < ApplicationController
  before_action :authenticate_user!
  before_action :find_wishlist_item

  # GET /wishlist
  def index
    @wishlist = current_user.wishlist
  end

  # POST /wishlist
  def add_course
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

  # DELETE /wishlist
  def remove_course
    respond_to do |format|
      if @wishlist_item.destroy
        flash[:notice] = 'Course successfully removed from your wishlist'
        format.html { redirect_to params[:url] || wishlist_path }
      else
        flash[:notice] = 'An error occurred while attempting to remove the course from your wishlist'
        format.html { redirect_to params[:url] || wishlist_path }
      end
    end
  end

  private

  def find_wishlist_item
    @wishlist_item = WishlistItem.where(user: current_user, course_id: params[:course_id])
                                 .first_or_initialize
  end
end
