module ApplicationHelper
  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  #Returns the full title on a per-page basis
  def full_title(page_title="")
    base_title = "The Jolly Advisor"
    
    if page_title.empty?
      base_title
    else
      "#{page_title}|#{base_title}"
    end
  end
end
