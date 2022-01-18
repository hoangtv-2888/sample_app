module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def find_followed_by_user_id user
    current_user.active_relationships.find_by followed_id: user.id
  end
end
