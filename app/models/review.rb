class Review < ActiveRecord::Base
  belongs_to :course
  belongs_to :professor
  belongs_to :user
  has_many :votes, class_name: 'ReviewVote'

  def helpfulness
    votes.map(&:score).reduce(0, :+)
  end

  def downvote(user)
    vote = ReviewVote.where(review: self, user: user).first_or_initialize
    return false if vote.score == -1
    vote.update_attributes(score: -1)
  end

  def upvote(user)
    vote = ReviewVote.where(review: self, user: user).first_or_initialize
    return false if vote.score == 1
    vote.update_attributes(score: 1)
  end
end
