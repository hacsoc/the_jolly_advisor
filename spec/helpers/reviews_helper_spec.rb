require 'rails_helper'

RSpec.describe ReviewsHelper, type: :helper do
  describe '#disable_vote_link?' do
    let(:review) { FactoryGirl.create(:review) }
    let(:user) { FactoryGirl.create(:user) }
    before { FactoryGirl.create_list(:review_vote, 2, review: review) }

    context 'when the user has not voted for the review' do
      it 'returns false' do
        expect(helper.disable_vote_link?(review, user, 1)).to be false
        expect(helper.disable_vote_link?(review, user, -1)).to be false
      end
    end

    context 'when the user has voted for the review with the same score' do
      it 'returns true for upvotes' do
        FactoryGirl.create(:review_vote, review: review, user: user, score: 1)
        expect(helper.disable_vote_link?(review, user, 1)).to be true
      end

      it 'returns true for downvotes' do
        FactoryGirl.create(:review_vote, review: review, user: user, score: -1)
        expect(helper.disable_vote_link?(review, user, -1)).to be true
      end
    end

    context 'when the user has voted for the review with a different score' do
      it 'returns false for upvotes' do
        FactoryGirl.create(:review_vote, review: review, user: user, score: -1)
        expect(helper.disable_vote_link?(review, user, 1)).to be false
      end

      it 'returns false for downvotes' do
        FactoryGirl.create(:review_vote, review: review, user: user, score: 1)
        expect(helper.disable_vote_link?(review, user, -1)).to be false
      end
    end
  end
end
