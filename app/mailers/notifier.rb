class Notifier < ActionMailer::Base
  default from: ENV['MAIL_ADDRESS']

  # TODO ensure email is actually sent out.
  def password_reset_instructions(user)
    @user = user
    @reset_link = edit_reset_url(user.perishable_token)
    mail(
      subject:      'Password Reset Instructions',
      to:           user.email
    )
  end
end