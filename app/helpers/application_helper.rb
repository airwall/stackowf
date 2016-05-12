module ApplicationHelper
  def show_username(assign)
    show_username = assign.user.try(:username?) ? assign.user.username : "%username%"
  end

  def views_action(object)
    if user_signed_in? && current_user.author_of?(object)
      render "views_action", object: object
    end
  end
end
