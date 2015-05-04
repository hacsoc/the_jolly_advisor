class Review < ActiveRecord::Base
  # Reviews should paginate 5 per page by default
  paginates_per 5

  belongs_to :course
  belongs_to :professor
  belongs_to :user

  def downvote
    update_attributes(helpfulness: helpfulness - 1)
  end

  def upvote
    update_attributes(helpfulness: helpfulness + 1)
  end
end
