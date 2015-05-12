module ReviewsHelper
  def disable_vote_link?(review, user, score)
    review.votes.any? { |v| v.user == user && v.score == score }
  end
end
