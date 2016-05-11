module ApplicationHelper
  def username(id)
    id != nil ? username = User.find(id).email : username = "%username%"
  end
end
