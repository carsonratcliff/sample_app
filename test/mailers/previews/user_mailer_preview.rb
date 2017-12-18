# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
  	# 11.18 - Defining user for account activation test
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    # 12.10 - Working preview method for password reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end
