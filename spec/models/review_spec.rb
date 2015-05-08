require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should belong_to :course }
  it { should belong_to :professor }
  it { should belong_to :user }
  it { should have_many :votes }

  let(:review) { FactoryGirl.create(:review) }

  describe '#helpfulness' do
    before { ReviewVote.where(review: review).destroy_all }

    context 'when there are no votes for the review' do
      it 'returns 0' do
        expect(review.helpfulness).to eq 0
      end
    end

    it 'returns the difference between positive and negative votes' do
      FactoryGirl.create_list(:review_vote, 3, review: review, score: 1)
      FactoryGirl.create_list(:review_vote, 2, review: review, score: -1)
      expect(review.helpfulness).to eq 1
    end
  end

  describe '#upvote' do
    let(:user) { FactoryGirl.create(:user) }
    before { ReviewVote.where(review: review, user: user).destroy_all }

    context 'when the user has not voted for the review' do
      it 'increases helpfulness by 1' do
        helpfulness = review.helpfulness
        review.upvote(user)
        expect(review.reload.helpfulness).to eq (helpfulness + 1)
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
        expect(review.reload.helpfulness).to eq helpfulness
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
        expect(review.reload.helpfulness).to eq (helpfulness + 2)
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
      it 'decreases helpfulness by 1' do
        helpfulness = review.helpfulness
        review.downvote(user)
        expect(review.reload.helpfulness).to eq (helpfulness - 1)
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
        expect(review.reload.helpfulness).to eq helpfulness
      end

      it 'returns false' do
        expect(review.downvote(user)).to be false
      end
    end

    context 'when the user has already upvoted' do
      before { FactoryGirl.create(:review_vote, review: review, user: user, score: 1) }

      it 'decreases the helpfulness by 2' do
        helpfulness = review.helpfulness
        review.downvote(user)
        expect(review.reload.helpfulness).to eq (helpfulness - 2)
      end

      it 'does not create any new votes' do
        count = ReviewVote.count
        review.downvote(user)
        expect(ReviewVote.count).to eq count
      end
    end
  end
end
