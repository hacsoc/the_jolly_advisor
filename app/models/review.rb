class Review < ActiveRecord::Base
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
