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

  def add_icon_to_attachment(f)
    %w(jpg jpeg png gif).any? { |str| f.downcase.include? str } ? "glyphicon glyphicon-picture" : "glyphicon glyphicon-file"
  end

  def login_options
    @redirect_path ? {redirect_to: request.path} : {}
  end
  
end
