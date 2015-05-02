require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should belong_to :course }
  it { should belong_to :professor }
  it { should belong_to :user }

  let(:review) { FactoryGirl.create(:review) }

  describe '#upvote' do
    it 'should increase helpfulness by 1' do
      helpfulness = review.helpfulness
      review.upvote
      expect(review.helpfulness).to eq (helpfulness + 1)
    end

    it 'should persist the helpfulness to the database' do
      helpfulness = review.helpfulness
      review.upvote
      expect(review.reload.helpfulness).to eq (helpfulness + 1)
    end
  end

  describe '#downvote' do
    it 'should decrease helpfulness by 1' do
      helpfulness = review.helpfulness
      review.downvote
      expect(review.helpfulness).to eq (helpfulness - 1)
    end

    it 'should persist the helpfulness to the database' do
      helpfulness = review.helpfulness
      review.downvote
      expect(review.reload.helpfulness).to eq (helpfulness - 1)
    end
  end
end
