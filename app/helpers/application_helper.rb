module ApplicationHelper
  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end
end
