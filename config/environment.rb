# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

if ENV['SENTRY_URL']
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_URL']
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end