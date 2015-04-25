require 'rails_helper'

RSpec.describe WishlistHelper, type: :helper do
  describe '#add_remove_link' do
    before do
      @id_set = [1, 2]
      allow(controller.request).to receive(:original_url).and_return('foo')
    end

    context 'when the id set includes the course id' do
      it 'should return a link to remove the id' do
        result = %{<a rel="nofollow" data-method="delete" href="/wishlist?course_id=1&amp;} +
                 %{url=foo">Remove from my wishlist</a>}
        expect(helper.add_remove_link(@id_set, double(id: 1))).to eq result
      end
    end

    context 'when the id set does not include the course id' do
      it 'should return a link to add the id' do
        result = %{<a rel="nofollow" data-method="post" href="/wishlist?course_id=3&amp;url=foo">} +
                 %{Add to my wishlist</a>}
        expect(helper.add_remove_link(@id_set, double(id: 3))).to eq result
      end
    end
  end

  describe '#set_notify_link' do
    context 'when the item responds to notify with false' do
      before { @item = double(notify: false, course_id: 1) }

      it 'should return a link to turn on notifications' do
        result = %{<a rel="nofollow" data-method="put" } +
                 %{href="/wishlist?course_id=1&amp;wishlist_item%5Bnotify%5D=true">} +
                 %{Turn on notifications</a>}
        expect(helper.set_notify_link(@item)).to eq result
      end
    end

    context 'when the item responds to notify with true' do
      before { @item = double(notify: true, course_id: 1) }

      it 'should return a link to turn off notifications' do
        result = %{<a rel="nofollow" data-method="put" } +
                 %{href="/wishlist?course_id=1&amp;wishlist_item%5Bnotify%5D=false">} +
                 %{Turn off notifications</a>}
        expect(helper.set_notify_link(@item)).to eq result
      end
    end
  end
end
