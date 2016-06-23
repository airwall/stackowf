module FeatureHelper
  def sign_in(user)
    visit new_user_session_path(redirect_to: root_path)
    fill_in "Login", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"
  end

  def mock_auth_valid_hash(provider, email)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(provider: provider,
                                                                        uid: 123_456,
                                                                        info: { email: email })
  end

  def mock_auth_invalid_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
