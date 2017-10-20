class EventPropertiesController < ApplicationController
  def sort
    sorter = EventPropertyServices::Sorter.new(params[:sorted_ids])
    sorter.perform

    render status: :ok, json: { ok: true }
  end

  def index
    @event_properties = current_team.event_properties.includes(:options).in_order

    respond_to :html
  end

  def show
    @expanded = true
    @event_property = current_team.event_properties.find(params[:id])

    respond_to :html
  end

  def new
    @event_property = current_team.event_properties.build

    respond_to :html
  end

  def edit
    @event_property = current_team.event_properties.find(params[:id])

    respond_to :html
  end

  def create
    @event_property = current_team.event_properties.build(event_property_params)

    if @event_property.save
      redirect_to @event_property
    else
      render action: :new
    end
  end

  def update
    @event_property = current_team.event_properties.find(params[:id])
    @event_property.attributes = event_property_params

    if @event_property.save
      redirect_to @event_property
    else
      render action: :edit
    end
  end

  def destroy
    @event_property = current_team.event_properties.find(params[:id])
    @event_property.destroy

    redirect_to event_properties_path
  end

  private
  def event_property_params
    params.require(:event_property).permit(:name, :behaviour, :required)
  end
end