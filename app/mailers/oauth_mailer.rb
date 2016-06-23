class OauthMailer < ApplicationMailer
  def email_confirmation(authorization)
    @url = "#{confirm_email_url}?token=#{authorization.confirmation_hash}"
    @code = authorization.confirmation_hash.to_s
    mail(to: authorization.user.email, subject: "Confirm your email for stackowf")
  end
end
