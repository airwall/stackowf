class OauthMailer < ApplicationMailer
  def email_confirmation(authorization)
    @url = "#{confirm_email_url}?token=#{authorization.confirmation_hash}"
    mail(to: authorization.user.email, subject: 'Confirm your email for stackowf')
  end
end
