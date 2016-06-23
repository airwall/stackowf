class OauthServicesController < ApplicationController
  def new_email_oauth
  end

  def save_email_oauth
    email = params[:email]
    if !email.blank?
      auth = { provider: session[:provider], uid: session[:uid], info: { email: email } }
      authorization = User.find_for_oauth(auth)
      OauthMailer.email_confirmation(authorization).deliver_now
      flash[:notice] = 'Now you need to confirm your email. Check your mailbox'
      redirect_to new_user_session_path(redirect_to: root_path)
    else
      render new_email_oauth_path
    end
  end

  def confirm_email
    authorization = Authorization.find_by(confirmation_hash: params[:token])
    if authorization
      authorization.update(confirmed: true, confirmation_hash: Devise.friendly_token[0, 20])
      redirect_to "/users/auth/#{authorization.provider}"
    else
      flash[:alert] = 'Something went wrong'
      redirect_to new_user_session_path(redirect_to: root_path)
    end
  end
end
