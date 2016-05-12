module ApplicationHelper
  def username(id)
    username = !id.nil? ? User.find(id).email : "%username%"
  end

  def views_action(object)
    if user_signed_in? && current_user.author_of?(object)
      render "views_action", object: object
    end
  end
end
