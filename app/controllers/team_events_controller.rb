class TeamEventsController < ApplicationController

  def create
    team = Team.find(params[:team_id])
    event = Event.find(params[:event_id])

    unless event.team == current_team
      return redirect_to event_path(share.event)
    end

    authorize! event, :update

    share = TeamEvent.create(team: team, event: event)

    redirect_to sharing_event_path(share.event)
  end

  def destroy
    share = TeamEvent.find(params[:id])

    unless [share.event.team, share.team].include?(current_team)
      return redirect_to event_path(share.event)
    end

    authorize! share.event, :update

    share.destroy

    redirect_to sharing_event_path(share.event)
  end

end
