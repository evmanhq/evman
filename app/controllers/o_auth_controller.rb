class OAuthController < ApplicationController

  skip_before_action :authenticate!
  skip_before_action :require_team!
  skip_before_action :verify_authenticity_token

  def callback
    return redirect_to root_path if params[:error]

    user = User.o_auth(env['omniauth.auth'], current_user)

    if user
      session[:user_id] = user.id
      user.token ||= Digest::SHA256.hexdigest(SecureRandom.hex)
      user.password ||= Digest::SHA256.hexdigest(SecureRandom.hex)
      user.save!

      if session[:invitation]
        invitation = TeamInvitation.where(:code => session[:invitation]).first
        if invitation
          user.email = invitation.email
          user.save!
          session.delete(:invitation)
          return redirect_to(accept_team_invitation_path(invitation))
        end
      end

      if session[:new_team_membership]
        team = Team.where(id: session.delete(:new_team_membership)).first
        user.teams << team if team and !user.teams.include?(team)
      end
    end

    redirect_to (session[:'user_return_to'] || root_path).to_s
  end

  def failure
    redirect_to root_path
  end

end
