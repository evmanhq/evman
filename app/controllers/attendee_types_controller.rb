class AttendeeTypesController < ApplicationController

  def create
    @attendee_type = AttendeeType.new
    @attendee_type.name = params[:name]
    @attendee_type.team = current_team
    authorize! @attendee_type, :create
    @attendee_type.save

    redirect_to(settings_team_path(current_team))
  end

  def default
    @attendee_type = AttendeeType.find(params[:attendee_type_id])

    authorize! @attendee_type, :update
    AttendeeType.where(:team_id => current_team.id).update_all(:default => false)
    @attendee_type.default = true
    @attendee_type.save

    redirect_to(settings_team_path(current_team))
  end

  def destroy
    @attendee_type = AttendeeType.find(params[:id])

    return redirect_to(settings_team_path(current_team)) if @attendee_type.default

    authorize! @attendee_type, :destroy
    @attendee_type.destroy

    Attendee.where(:attendee_type_id => params[:id]).update_all(:attendee_type_id => current_team.default_attendee_type)

    redirect_to(settings_team_path(current_team))
  end

end