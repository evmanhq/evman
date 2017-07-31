class EventTypesController < ApplicationController

  before_action :require_modal, only: [:new]

  def new
    @event_type = current_team.event_types.build
  end

  def edit
    @event_type = current_team.event_types.find(params[:id])
  end

  def create
    @event_type = current_team.event_types.build(event_type_params)
    authorize! @event_type, :create

    if @event_type.save
      redirect_to settings_team_path(current_team)
    else
      render action: :edit
    end
  end

  def update
    @event_type = current_team.event_types.find(params[:id])
    @event_type.attributes = event_type_params
    authorize! @event_type, :update

    if @event_type.save
      redirect_to settings_team_path(current_team)
    else
      render action: :edit
    end
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

  private

  def event_type_params
    params.require(:event_type).permit(:name, :color)
  end

end