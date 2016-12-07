class EventNotesController < ApplicationController

  before_action :require_modal, only: [:new]

  def new
    @event = Event.includes(:event_notes).find(params[:event_id])
  end

  def create
    event = Event.includes(:event_notes).find(params[:id])

    @note = EventNote.new
    @note.content = params[:event_note][:content]
    @note.event = event
    @note.user = current_user

    authorize! @note, :create
    @note.save

    redirect_to(event_path(event))
  end

end
