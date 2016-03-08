require 'rails_helper'

RSpec.describe WishlistController, type: :controller do
  let(:cas_session) { {cas_user: 'bob'} }

  describe 'PUT #update' do
    let(:wishlist_item) { double('wishlist_item') }
    let(:relation) { double(first_or_initialize: wishlist_item) }

    it 'updates based on course id' do
      allow(WishlistItem).to receive(:where).and_return relation
      expect(wishlist_item).to receive(:update)

      params = {
        course_id: 1,
        wishlist_item: {notify: nil},
      }

      put :update, params, cas_session
      expect(response).to redirect_to(wishlist_path)
    end

    it 'updates based on course title' do
      title = 'course_title'

      allow(WishlistItem).to receive(:where).and_return relation
      expect(Course).to receive(:search).with(title).and_return(spy)
      expect(wishlist_item).to receive(:update)

      params = {
        course_title: title,
        wishlist_item: {notify: nil},
      }

      put :update, params, cas_session
      expect(response).to redirect_to(wishlist_path)
    end
  end
end
