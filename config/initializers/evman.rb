ActionDispatch::Http::URL.tld_length = ENV['EVMAN_DOMAIN'].to_s.split('.').size - 1

Rails.application.config.action_mailer.default_url_options = {host: ENV['EVMAN_DOMAIN'], protocol: ENV['EVMAN_SCHEME']}

Rails.application.config.session_store :cookie_store, key: '_evman_session', domain: ENV['EVMAN_DOMAIN']

if ENV['S3_BUCKET_NAME']
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    bucket: ENV['S3_BUCKET_NAME'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    s3_region: ENV['AWS_REGION']
  }
end

Dir.glob("#{Rails.root}/app/themes/*/assets/*").each do |dir|
  Rails.application.config.assets.paths << dir
end