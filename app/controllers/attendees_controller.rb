class AttendeesController < ApplicationController

  def create
    data = params[:attendee]

    user = User.find(data['user_id'])
    event = Event.find(data['event_id'])

    attendee = Attendee.where(
        :user_id => data['user_id'],
        :event_id => data['event_id'],
        :attendee_type_id => data['type_id']).first

    attendee = Attendee.new unless attendee

    attendee.user = user
    attendee.event = event
    attendee.attendee_type = AttendeeType.find(data['attendee_type_id'])


    authorize! attendee, :create
    attendee.save

    redirect_to(event_path(event))
  end

  def destroy
    attendee = Attendee.where(:id => params[:id]).first

    authorize! attendee, :destroy
    attendee.destroy

    redirect_to(event_path(attendee.event))
  end

end
