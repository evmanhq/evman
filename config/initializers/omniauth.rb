Rails.application.config.middleware.use(OmniAuth::Builder) do
  provider :github, ENV['GITHUB_ID'], ENV['GITHUB_KEY'], scope: 'user:email'
  provider :slack, ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET'], scope: 'client,chat:write:user,chat:write:bot'
  provider :google_oauth2, ENV['GOOGLE_ID'], ENV['GOOGLE_KEY'], {
      name: 'google'
  }
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_KEY']
  provider :twitter, ENV['TWITTER_ID'], ENV['TWITTER_KEY']
  provider :gitlab, ENV['GITLAB_ID'], ENV['GITLAB_KEY']

  provider :google_oauth2, ENV['GOOGLE_ID'], ENV['GOOGLE_KEY'], {
      :name => 'google_calendar',
      :scope => 'calendar',
      :prompt => 'consent',
      :include_granted_scopes => 'true',
      :access_type => 'offline'
  }
end

OmniAuth.config.logger = Logger.new($stdout)

OmniAuth.config.full_host = ENV['EVMAN_HOST']
