class PerformanceMetricEntriesController < ApplicationController
  before_action :require_modal, only: [:new, :edit]
  before_action :find_event, only: [:new]

  def new
    @entry = @event.performance_metric_entries.build

    respond_to :html
  end

  def edit
    @entry = PerformanceMetricEntry.find(params[:id])

    respond_to :html
  end

  def create
    @entry = PerformanceMetricEntry.new(entry_params)

    if @entry.save
      redirect_to @entry.event
    else
      render action: :new
    end
  end

  def update
    @entry = PerformanceMetricEntry.find(params[:id])
    @entry.attributes = entry_params

    if @entry.save
      redirect_to @entry.event
    else
      render action: :new
    end
  end

  def destroy
    @entry = PerformanceMetricEntry.find(params[:id])
    @entry.destroy

    redirect_to @entry.event
  end

  private
  def entry_params
    params.require(:performance_metric_entry).permit(:event_id, :performance_metric_id, :target, :actual)
  end


  def find_event
    @event = current_team.events.find(params[:event_id])
  end
end