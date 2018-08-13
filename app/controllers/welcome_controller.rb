require 'digest'
require 'securerandom'

class WelcomeController < ApplicationController

  skip_before_action :authenticate!, :require_team!, :announcements

  layout 'welcome'

  def index
    respond_to do |format|
      format.html do
        redirect_to(dashboard_path) if current_user
      end
      format.ics do
        render :nothing => true, :status => 404
      end
    end
  end

  def authenticate
    user = User.where(:email => params[:email]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.token = Digest::SHA256.hexdigest(SecureRandom.hex) unless user.token
      user.save
      return render json: {
          token: user.token,
          id: user.id,
          name: user.name,
          avatar: user.avatar_url,
          teams: user.teams.map do |team|
            { id: team.id, name: team.name, subdomain: team.subdomain}
          end
      }
    end
    render plain: 'FAILED'
  end

  def signin
    user = User.where(:email => params[:user][:email]).first

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      user.token = Digest::SHA256.hexdigest(SecureRandom.hex) unless user.token
      user.save
      return redirect_to(dashboard_path)
    end
    redirect_to(root_path)
  end

  def signout
    session.destroy
    redirect_to(root_path)
  end

end
