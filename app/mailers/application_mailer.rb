class ApplicationMailer < ActionMailer::Base
  # 11.11 - default from address for account activation email
  default from: 'noreply@example.com'
  layout 'mailer'
end
