class ApplicationMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']
  layout 'mailer'
end
