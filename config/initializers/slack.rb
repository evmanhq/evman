class Slack

  def initialize(app, *args, &block)
    @app = app
  end

  def call(env)
    @app.call(env)
  end

  def self.api
    unless @client
      @client = Patron::Session.new
      @client.timeout = 10
      @client.base_url = 'https://slack.com'
      @client.headers['User-Agent'] = 'myapp/1.0'
    end
    @client
  end

  def self.post(content, target = nil)
    return if Rails.env.development?
    unless @hooks
      @hooks = Patron::Session.new
      @hooks.timeout = 10
      @hooks.base_url = 'https://hooks.slack.com'
      @hooks.headers['User-Agent'] = 'myapp/1.0'
    end

    if target.kind_of?(Team)
      return unless target.slack_setting
      slack = target.slack_setting
      target = slack.hook_url.sub('https://hooks.slack.com/services/', '')
    end

    if content.kind_of?(String)
      content = {:text => content}
    end

    content = MultiJson.dump(content)

    Rails.logger.info(@hooks.post("/services/#{target}", content, {'Content-Type' => 'application/json'}).body)
  end

  def self.call(method, team, opts={}, &block)
    return unless team.slack_setting
    slack = team.slack_setting
    options = {:token => slack.bot_token}.merge(opts)
    response = api.post("/api/#{method}", options)
    if response.status == 200
      MultiJson.load(response.body)
    else
      {}
    end
  end

  def self.list_users(team)
    call('users.list', team)
  end

end