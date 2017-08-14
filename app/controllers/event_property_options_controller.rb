class EventPropertyOptionsController < ApplicationController
  # TODO: authorization
  before_action :find_event_property, only: [:new]
  def new
    @event_property_option = @event_property.options.build

    respond_to :html
  end

  def edit
    @event_property_option = EventPropertyOption.find(params[:id])

    respond_to :html
  end

  def create
    @event_property_option = EventPropertyOption.new(event_property_option_params)

    if @event_property_option.save
      redirect_to @event_property_option.property
    else
      render action: :new
    end
  end

  def update
    @event_property_option = EventPropertyOption.find(params[:id])
    @event_property_option.attributes = event_property_option_params

    if @event_property_option.save
      redirect_to @event_property_option.property
    else
      render action: :edit
    end
  end

  def destroy
    @event_property_option = EventPropertyOption.find(params[:id])
    @event_property_option.destroy

    redirect_to @event_property_option.property
  end

  private
  def find_event_property
    @event_property = current_team.event_properties.find(params[:event_property_id])
  end

  def event_property_option_params
    params.require(:event_property_option).permit(:name, :property_id, :parent_id)
  end
end