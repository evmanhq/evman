class EventTalksController < ApplicationController

  before_action :require_modal, only: [:new, :edit, :show]

  def show
    @event_talk = EventTalk.find(params[:id])

    respond_to :html
  end

  def new
    @event_talk = EventTalk.new(user: current_user)
    @event_talk.event = Event.find(params[:event_id]) if params[:event_id]
    @event_talk.talk = Talk.find(params[:talk_id]) if params[:talk_id]

    respond_to :html
  end

  def edit
    @event_talk = EventTalk.find(params[:id])

    respond_to :html
  end

  def create
    attributes = event_talk_params
    attributes[:state] = nil if attributes[:state] == 'on'

    @event_talk = EventTalk.new(attributes)
    authorize! @event_talk, :create
    if @event_talk.save
      redirect_back(fallback_location: @event_talk.talk)
    else
      render action: :new
    end
  end

  def update
    attributes = event_talk_params
    attributes[:state] = nil if attributes[:state] == 'on'

    @event_talk = EventTalk.find(params[:id])
    authorize! @event_talk, :update
    if @event_talk.update_attributes(attributes)
      redirect_back(fallback_location: @event_talk.talk)
    else
      render action: :edit
    end
  end

  def destroy
    event_talk = EventTalk.where(:id => params[:id]).first
    authorize! @event_talk, :destroy
    event_talk.destroy

    redirect_back(fallback_location: talks_path)
  end

  private
  def event_talk_params
    params.require(:event_talk).permit(:user_id, :event_id, :talk_id, :state, :description)
  end

end
