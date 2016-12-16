class ApplicationController < ActionController::Base

  include ApplicationHelper
  include Authorization::ControllerHelpers

  protect_from_forgery with: :null_session

  layout :select_layout

  append_before_action :get_current_user
  append_before_action :get_current_team
  append_before_action :validate_user_info!
  append_before_action :authenticate!
  append_before_action :require_team!

  append_before_action :breadcrumb_nav

  before_action do
    prepend_view_path(Rails.root.join("app/themes/base/views"))
  end

  after_action do
    Thread.current[:dictator] = nil
  end

  if ['staging', 'production'].include?(Rails.env)
    rescue_from Exception do |e|
      message = {
          :fallback => "Exception #{e.message}",
          :pretext => "Exception #{e.message}",
          :fields => [
              {:title => 'URL', :value => request.original_url, :short => false},
              {:title => 'Backtrace', :value => e.backtrace.take(5).join("\n"), :short => false}
          ]
      }

      Slack.post(message, ENV['SLACK_ID'])
      raise e
    end
  end

  rescue_from Authorization::UnauthorizedAccess, with: :deny_access

  def deny_access exception
    @exception = exception

    respond_to do |format|
      format.js { render file: 'application/deny_access', status: :unauthorized  }
      format.html { render file: 'application/deny_access' }
    end
  end

  protected

  def require_modal
    @forced_layout = if request.headers['X-EvMan-Modal'] == 'true'
                       'modal'
                     else
                       'inset_modal'
                     end
  end

  def select_layout
    return @forced_layout if @forced_layout.present?
    if request.headers['X-EvMan-Modal'] == 'true'
      'modal'
    else
      'application'
    end
  end

  def current_user
    @current_user
  end

  def current_team
    @current_team
  end

  def get_current_user
    if params[:invitation]
      session[:invitation] = params[:invitation]
    end

    if Rails.env.test? and cookies[:user_id]
      session[:user_id] = cookies[:user_id].to_i
    end

    # User already logged in
    @current_user = User.where(:id => session[:user_id] || -1).first

    # Login in with user token
    unless @current_user
      token = params['user_token'] || request.headers['X-USER-TOKEN']
      if token
        @current_user = User.where(:token => token).first
      end
    end
  end

  def get_current_team
    @current_team = Team.where(subdomain: request.subdomain).first
    @current_team ||= current_user.teams.first if current_user
  end

  def validate_user_info!
      redirect_to(edit_user_path(current_user)) if current_user && (!current_user.password_digest)
  end

  def authenticate!
    unless current_user
      session[:redirect_after_login] = request.fullpath
      session[:domain_after_login] = request.subdomain
      return redirect_to(root_url(subdomain: 'www'))
    end


    if current_team and !current_user.teams.include?(current_team)
      team = @current_user.teams.first
      if team
        return redirect_to(subdomain: team.subdomain)
      else
        return redirect_to(user_path(current_user))
      end
    end

    Authorization.activate(current_user, current_team)

    if session[:redirect_after_login]
      path = session[:redirect_after_login]
      session.delete(:redirect_after_login)
      redirect_to(path, subdomain: (session[:domain_after_login] || request.subdomain))
    end
  end

  def require_team!
    redirect_to(user_path(current_user)) if current_user && !current_team
  end

  def nginx_download(url)
    response.headers['X-Accel-Redirect'] = url.gsub(/(https?:)?\/\/s3\.amazonaws\.com/,'/attachments_downloads')
    render :text => ''
  end

  helper_method :breadcrumb_nav

  def breadcrumb_nav
    @breadcrumb_nav ||= BreadcrumbNav.new
  end
  
  helper_method :main_menu

  def main_menu
    @main_menu ||= begin
      menu = EvmanMenu::Menu.new
      menu.configure do |m|
        if current_team
          m.page name: 'Dashboard', path: dashboard_path, icon: 'dashboard'  if can? :event, :read

          # Events
          m.section name: 'Events', icon: 'train' do |s|
            s.page name: 'Overview', path: events_path, icon: 'train' do
              capture controller: :events, action: :show
              capture controller: :events, action: :edit
            end

            s.page name: 'Create event', path: new_event_path, icon: 'plus', modal: true
            s.page name: 'Archive', path: archive_events_path, icon: 'archive'
            s.page name: 'Export', path: export_events_path, icon: 'table'
          end if can? :event, :read

          m.page name: 'Calendar', path: calendars_path, icon: 'calendar' do
            capture controller: :calendars, action: :show
          end if can? :event, :read

          m.section name: 'Talks', icon: 'file-text-o' do |s|
            s.page name: 'Overview', path: talks_path, icon: 'file-text-o'
            s.page name: 'Create talk', path: new_talk_path, icon: 'plus', modal: true
          end if can? :talk, :read

          # Team
          m.section name: 'Team', icon: 'group' do |s|
            s.page name: 'Overview', icon: 'group', path: team_path(current_team) if can? :team, :members_read
            s.page name: 'Settings', icon: 'cogs', path: settings_team_path(current_team) if authorized? current_team, :settings
            s.page name: 'Roles', icon: 'user-md', path: roles_path if can? :role, :read
            s.page name: 'Tags', icon: 'tag', path: tags_path if can? :team, :tags
            s.page name: 'Statistics', icon: 'line-chart', path: statistics_teams_path if can? :team, :statistics
          end

          m.section name: 'Warehouse', icon: 'archive' do |s|
            s.capture controller: :warehouses
            s.capture controller: :warehouse_items
            s.capture controller: :warehouse_batches

            current_team.warehouses.order(:name).each do |warehouse|
              s.page name: warehouse.name, icon: 'archive', path: warehouse
            end
            s.page name: 'Settings', icon: 'cogs', path: warehouses_path
          end if can? :warehouse, :read
        end

        m.section name: 'Profile', icon: 'user' do |s|
          s.page name: 'Profile', icon: 'user', path: user_path(current_user)
          s.page name: 'Avatars', icon: 'camera', path: avatars_user_path(current_user)
          s.page name: 'Biographies', icon: 'book', path: biographies_user_path(current_user)
          s.page name: 'Calendars', icon: 'calendar', path: calendars_user_path(current_user)
        end
      end
      menu
    end
  end

end