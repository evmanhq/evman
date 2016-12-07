class EventTypesController < ApplicationController

  def create
    @event_type = EventType.new
    @event_type.name = params[:name]
    @event_type.team = current_team
    authorize! @event_type, :create
    @event_type.save

    redirect_to(settings_team_path(current_team))
  end

  def default
    @event_type = EventType.find(params[:event_type_id])

    authorize! @event_type, :update
    EventType.where(:team_id => current_team.id).update_all(:default => false)

    @event_type.default = true
    @event_type.save

    redirect_to(settings_team_path(current_team))
  end

  def destroy
    @event_type = EventType.find(params[:id])

    return redirect_to(settings_team_path(current_team)) if @event_type.default

    authorize! @event_type, :destroy
    @event_type.destroy

    Event.where(:event_type_id => params[:id]).update_all(:event_type_id => current_team.default_event_type)
    Talk.where(:event_type_id => params[:id]).update_all(:event_type_id => current_team.default_event_type)

    redirect_to(settings_team_path(current_team))
  end

end