class SlackController < ApplicationController

  skip_before_action :authenticate!

  class << self

    def client
      unless @client
        @client = Patron::Session.new
        @client.timeout = 10
        @client.base_url = 'https://hooks.slack.com'
        @client.headers['User-Agent'] = 'myapp/1.0'
      end
      @client
    end

  end

  before_action do
    if ENV['SLACK_TOKEN'] != params['token']
      render :nothing => true, :status => 404
    end

    @team_id = params['team_id']
    @user_id = params['user_id']
    @command = params['command']
    @response = params['response_url'].sub('https://hooks.slack.com', '')

    @su = SlackUser.where(:username => @user_id).first
    if @su
      @user = @su.user
      Authorization.activate(@user, @user.teams.first)
    else
      post(response, {:text => 'You do not have integration with EvMan'})
      render :nothing => true, :status => 404
    end
  end

  def events
     data = {
        :text => 'Your upcoming events',
        :attachments => @user.events.where('begins_at > NOW()').order(:begins_at).limit(5).all.map { |event|
          {
              :text => "#{event.name} starts #{event.begins_at} in #{event.full_location}"
          }
        }
    }

    post(data)
  end

  protected

  def post(data)
    self.class.client.post(@response, MultiJson.dump(data))
    render :nothing => true, :status => 200
  end

end
