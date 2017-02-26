require 'rails_helper'

RSpec.describe WishlistController, type: :controller do
  let(:cas_session) { {cas_user: 'bob'} }
  let(:wishlist_item) { double('wishlist_item') }
  let(:relation) { double(first_or_initialize: wishlist_item) }

  describe 'POST #add_course' do
    context 'when the item can be saved' do
      before { allow(wishlist_item).to receive(:save).and_return true }

      it 'redirects to the requested url' do
        url = 'somewhere_else'
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
          url: url,
        }

        post :add_course, params: params, session: cas_session
        expect(response).to redirect_to(url)
      end

      it 'notifies the user' do
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
        }

        post :add_course, params: params, session: cas_session
        expect(response).to redirect_to(wishlist_path)
        expect(flash[:notice]).to include 'success'
      end
    end

    context 'when the item cannot be saved' do
      before { allow(wishlist_item).to receive(:save).and_return false }

      it 'redirects to the requested url' do
        url = 'somewhere_else'
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
          url: url,
        }

        post :add_course, params: params, session: cas_session
        expect(response).to redirect_to(url)
      end

      it 'notifies the user' do
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
        }

        post :add_course, params: params, session: cas_session
        expect(response).to redirect_to(wishlist_path)
        expect(flash[:notice]).to include 'error'
      end
    end
  end

  describe 'PUT #update' do
    it 'updates based on course id' do
      allow(WishlistItem).to receive(:where).and_return relation
      expect(wishlist_item).to receive(:update)

      params = {
        course_id: 1,
        wishlist_item: {notify: nil},
      }

      put :update, params: params, session: cas_session
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

      put :update, params: params, session: cas_session
      expect(response).to redirect_to(wishlist_path)
    end
  end

  describe 'DELETE #remove_course' do
    context 'when the item can be saved' do
      before { allow(wishlist_item).to receive(:destroy).and_return true }

      it 'redirects to the requested url' do
        url = 'somewhere_else'
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
          url: url,
        }

        delete :remove_course, params: params, session: cas_session
        expect(response).to redirect_to(url)
      end

      it 'notifies the user' do
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
        }

        delete :remove_course, params: params, session: cas_session
        expect(response).to redirect_to(wishlist_path)
        expect(flash[:notice]).to include 'success'
      end
    end

    context 'when the item cannot be saved' do
      before { allow(wishlist_item).to receive(:destroy).and_return false }

      it 'redirects to the requested url' do
        url = 'somewhere_else'
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
          url: url,
        }

        delete :remove_course, params: params, session: cas_session
        expect(response).to redirect_to(url)
      end

      it 'notifies the user' do
        allow(WishlistItem).to receive(:where).and_return relation

        params = {
          course_id: 1,
        }

        delete :remove_course, params: params, session: cas_session
        expect(response).to redirect_to(wishlist_path)
        expect(flash[:notice]).to include 'error'
      end
    end
  end
end
