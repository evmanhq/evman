ActionMailer::Base.smtp_settings = {
    :port           => ENV['EMAIL_PORT'],
    :address        => ENV['EMAIL_HOST'],
    :user_name      => ENV['EMAIL_USER'],
    :password       => ENV['EMAIL_PASS'],
    :authentication => :plain,
}

ActionMailer::Base.delivery_method = :smtp