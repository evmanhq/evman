class OAuthController < ApplicationController

  skip_before_action :authenticate!
  skip_before_action :require_team!
  skip_before_action :verify_authenticity_token

  def callback
    return redirect_to root_path if params[:error]

    adapter = Authentication::OmniauthAdapter.new(request.env['omniauth.auth'])

    if current_user
      adapter.register_identity(current_user) unless adapter.identity_exists?
    else # no current_user
      if adapter.identity_exists?
        user = adapter.identity.user
        session[:user_id] = user.id
        # cookies[:user_id] = user.id if Rails.env.test?
        user.assure_credentials # fills token and password if empty
      else # no current_user && no identity
        if ENV['EVMAN_REQUIRE_INVITATION'] == 'true' && !session[:invitation]
          redirect_to root_path
          return
        end
        user = adapter.register_user
        session[:user_id] = user.id
        # cookies[:user_id] = user.id if Rails.env.test?
        return if session[:invitation] and process_invitation(user)
      end
    end

    redirect_to (session[:'user_return_to'] || root_path).to_s
  end

  def failure
    redirect_to root_path
  end

  private
  def process_invitation user
    invitation = TeamInvitation.where(:code => session[:invitation]).first
    if invitation
      user.email = invitation.email
      user.save!
      user.add_email(invitation.email)
      session.delete(:invitation)
      redirect_to(accept_team_invitation_path(invitation))
      return true
    end
    false
  end

end
