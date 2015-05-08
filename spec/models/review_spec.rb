require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should belong_to :course }
  it { should belong_to :professor }
  it { should belong_to :user }

  let(:review) { FactoryGirl.create(:review) }

  describe '#upvote' do
    let(:user) { FactoryGirl.create(:user) }
    before { ReviewVote.where(review: review, user: user).destroy_all }

    context 'when the user has not voted for the review' do
      it 'increases helpfulness by 1' do
        helpfulness = review.helpfulness
        review.upvote(user)
        expect(review.helpfulness).to eq (helpfulness + 1)
      end

      it 'creates a new review vote' do
        count = ReviewVote.count
        review.upvote(user)
        expect(ReviewVote.count).to eq (count + 1)
      end
    end

    context 'when the user has already upvoted' do
      before { FactoryGirl.create(:review_vote, review: review, user: user, score: 1) }

      it 'does not change helpfulness' do
        helpfulness = review.helpfulness
        review.upvote(user)
        expect(review.helpfulness).to eq helpfulness
      end

      it 'returns false' do
        expect(review.upvote(user)).to be false
      end
    end

    context 'when the user has already downvoted' do
      before { FactoryGirl.create(:review_vote, review: review, user: user, score: -1) }

      it 'increases the helpfulness by 2' do
        helpfulness = review.helpfulness
        review.upvote(user)
        expect(review.helpfulness).to eq (helpfulness + 2)
      end

      it 'does not create any new votes' do
        count = ReviewVote.count
        review.upvote(user)
        expect(ReviewVote.count).to eq count
      end
    end
  end

  describe '#downvote' do
    let(:user) { FactoryGirl.create(:user) }
    before { ReviewVote.where(review: review, user: user).destroy_all }

    context 'when the user has not voted for the review' do
      it 'increases helpfulness by 1' do
        helpfulness = review.helpfulness
        review.downvote(user)
        expect(review.helpfulness).to eq (helpfulness + 1)
      end

      it 'creates a new review vote' do
        count = ReviewVote.count
        review.downvote(user)
        expect(ReviewVote.count).to eq (count + 1)
      end
    end

    context 'when the user has already downvoted' do
      before { FactoryGirl.create(:review_vote, review: review, user: user, score: -1) }

      it 'does not change helpfulness' do
        helpfulness = review.helpfulness
        review.downvote(user)
        expect(review.helpfulness).to eq helpfulness
      end

      it 'returns false' do
        expect(review.downvote(user)).to be false
      end
    end

    context 'when the user has already upvoted' do
      before { FactoryGirl.create(:review_vote, review: review, user: user, score: 1) }

      it 'increases the helpfulness by 2' do
        helpfulness = review.helpfulness
        review.downvote(user)
        expect(review.helpfulness).to eq (helpfulness + 2)
      end

      it 'does not create any new votes' do
        count = ReviewVote.count
        review.downvote(user)
        expect(ReviewVote.count).to eq count
      end
    end
  end
end
