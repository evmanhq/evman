class TeamsController < ApplicationController

  skip_before_filter :require_team!, :only => [:new, :create, :select]

  def index
    respond_to do |response|
      response.json do
        render :json => current_user.teams.all
      end
      response.html do
        redirect_to(team_path(current_team))
      end
    end
  end

  def new
    @team = Team.new

    respond_to :html
  end

  def show
    @team = Team.find(params[:id])
    authorize! @team, :read_members
  end

  def settings
    @team = Team.find(params[:id])
    authorize! @team, :read_options
  end

  def statistics
    start = DateTime.now.beginning_of_year
    stops = DateTime.now

    @talks_accepted = current_team.event_talks.where(state: true).where('begins_at > ? AND begins_at < ?', start, stops).count
    @talks_rejected = current_team.event_talks.where(state: false).where('begins_at > ? AND begins_at < ?', start, stops).count
    @talks_progress = current_team.event_talks.where(state: nil).where('begins_at > ? AND begins_at < ?', start, stops).count

    @talks_by_user = current_team.event_talks
                                 .select('users.name, count(users.id) as count')
                                 .joins(:user).group('users.id')
                                 .where('begins_at > ? AND begins_at < ?', start, stops)
                                 .order(:count => 'desc')

    @talks_by_user_accepted = current_team.event_talks
                          .select('users.name, count(users.id) as count')
                          .joins(:user).group('users.id')
                          .where(state: true)
                          .where('begins_at > ? AND begins_at < ?', start, stops)
                          .order(:count => 'desc')

    @events_by_type = current_team.events
                          .select('event_types.name, count(event_types.id) as count')
                          .joins(:event_type).group('event_types.id')
                          .where("committed = 't' and begins_at > ? AND begins_at < ?", start, stops)
                          .order(:count => 'desc')

    @events_by_continent = current_team.events
                          .select('continents.name, count(continents.id) as count')
                          .joins(:city => {country: :continent}).group('continents.id')
                          .where("committed = 't' and begins_at > ? AND begins_at < ?", start, stops)
                          .order(:count => 'desc')

    @events_by_country = current_team.events
                               .select('countries.name, count(countries.id) as count')
                               .joins(:city => :country).group('countries.id')
                               .where("committed = 't' and begins_at > ? AND begins_at < ?", start, stops)
                               .order(:count => 'desc')

    @events_by_user = current_team.events
                             .select('users.name, count(users.id) as count')
                             .joins(attendees: :user).group('users.id')
                             .where("committed = 't' and begins_at > ? AND begins_at < ?", start, stops)
                             .order(:count => 'desc')
  end

  def create
    @team = Team.new
    @team.name = params[:team][:name]
    @team.description = params[:team][:description]
    @team.save

    @membership = TeamMembership.new
    @membership.team = @team
    @membership.user = current_user
    @membership.active = true
    @membership.team_membership_type = TeamMembershipType.find_by_name('Owner')
    @membership.save

    authorization_profile = Authorization::Profile.new(role: { read: true, manage: true })
    @team.roles.create(name: "Default", default: true, authorization_profile: authorization_profile)

    redirect_to(team_path(@team, subdomain: @team.subdomain))
  end

  def slack
    if params[:error]
      return redirect_to(team_path(current_team))
    end

    if params[:code] && params[:state] == current_team.id.to_s
      session = Patron::Session.new
      session.base_url = 'https://slack.com'
      response = session.post('/api/oauth.access', {
                                                      :client_id => ENV['SLACK_CLIENT_ID'],
                                                      :client_secret => ENV['SLACK_CLIENT_SECRET'],
                                                      :code => params[:code]
                                                  })
      if response.status == 200
        data = JSON.load(response.body)

        if data['ok']
          slack = SlackSetting.find_or_create_by(:team_id => current_team.id)

          slack.access_token = data['access_token']
          slack.scope = data['scope']
          slack.team_name = data['team_name']
          slack.team_uid = data['team_id']

          if data['incoming_webhook']
            slack.hook_channel = data['incoming_webhook']['channel']
            slack.hook_channel_id = data['incoming_webhook']['channel_id']
            slack.hook_configuration = data['incoming_webhook']['configuration_url']
            slack.hook_url = data['incoming_webhook']['url']
          end

          if data['bot']
            slack.bot_id = data['bot']['bot_user_id']
            slack.bot_token = data['bot']['bot_access_token']
          end

          slack.save
        end
      end
    end

    redirect_to(settings_team_path(current_team))
  end

  def slack_sync
    slack = current_team.slack_setting
    data = Slack.list_users(current_team)
    if data['ok']
      members = []
      data['members'].each do |member|
        user = User.where(:email => member['profile']['email']).first
        if user
          members << member['id']
          info = {
              :slack_setting_id => slack.id,
              :user_id => user.id
          }
          su = SlackUser.find_or_create_by(info)
          su.username = member['id']
          su.save
        end
      end

      SlackUser.where('slack_setting_id=? AND username NOT IN (?)', slack, members).destroy_all
    end

    redirect_to(settings_team_path(current_team))
  end

  def select
    @team = Team.find(params[:id])
    respond_to do |response|
      response.json do
        render :json => current_team
      end
      response.html do
        redirect_to(dashboard_path(@team))
      end
    end
  end

end
