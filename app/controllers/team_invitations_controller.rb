class TeamInvitationsController < ApplicationController

  skip_before_action :require_team!, :only => [:accept, :decline]

  def create
    invitation = TeamInvitation.new
    invitation.code = Digest::MD5.hexdigest(DateTime.now.to_f.to_s + Random.new.rand.to_s)
    invitation.email = params['email']
    invitation.team = current_team
    invitation.user = User.where(:email => params['email']).first
    invitation.accepted = nil
    authorize! invitation, :create
    invitation.save

    UserMailer.new_invitation(invitation).deliver_now

    redirect_to(teams_path)
  end

  def destroy
    invitation = TeamInvitation.find(params[:id])
    invitation.destroy

    redirect_to(teams_path)
  end

  def accept
    invitation = TeamInvitation.find(params[:id])
    invitation.accepted = true
    invitation.save

    @membership = TeamMembership.new
    @membership.team = invitation.team
    @membership.user = current_user
    @membership.active = true
    @membership.team_membership_type = TeamMembershipType.find_by_name('Owner')
    @membership.save

    redirect_to(dashboard_path)
  end

  def decline
    invitation = TeamInvitation.find(params[:id])
    invitation.accepted = false
    invitation.save

    redirect_to(dashboard_path)
  end

end
