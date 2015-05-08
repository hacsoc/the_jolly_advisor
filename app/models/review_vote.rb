class ReviewVote < ActiveRecord::Base
  belongs_to :review
  belongs_to :user

  validates :score, numericality: { only_integer: true }
  validates :score, inclusion: [-1, 1]
end
