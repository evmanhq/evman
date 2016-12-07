class TeamMembersController < ApplicationController

  def destroy
    membership = TeamMembership.where(:user_id => params[:id], :team_id => params[:team_id]).first
    authorize! membership, :destroy
    membership.destroy

    redirect_to(teams_path)
  end

end
