class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_gon_user
  before_action :set_redirect_path, unless: :user_signed_in?


  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def set_gon_user
    gon.user_id = current_user.try(:id)
  end

  def set_redirect_path
    @redirect_path = request.path
  end

  def after_sign_in_path_for(resource)
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    elsif request.referer == new_session_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
end
