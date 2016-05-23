module ApplicationHelper
  def show_username(assign)
    assign.user.try(:username) || "%username%"
  end

  def show_link?(object)
    user_signed_in? && current_user.author_of?(object)
  end

  def views_action(object)
    if user_signed_in? && current_user.author_of?(object)
      render "layouts/views_action", object: object
    end
  end
end
