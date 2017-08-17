class PerformanceMetricsController < ApplicationController
  before_action :require_modal, only: [:new, :edit]

  def index
    @performance_metrics = current_team.performance_metrics.order(name: :asc)

    respond_to :html
  end

  def show
    @performance_metric = current_team.performance_metrics.find(params[:id])

    respond_to :html
  end

  def new
    @performance_metric = current_team.performance_metrics.build

    respond_to :html
  end

  def edit
    @performance_metric = current_team.performance_metrics.find(params[:id])

    respond_to :html
  end

  def create
    @performance_metric = current_team.performance_metrics.build(performance_metric_params)

    if @performance_metric.save
      redirect_to performance_metrics_path
    else
      render action: :new
    end
  end

  def update
    @performance_metric = current_team.performance_metrics.find(params[:id])
    @performance_metric.attributes = performance_metric_params

    if @performance_metric.save
      redirect_to performance_metrics_path
    else
      render action: :edit
    end
  end

  def destroy
    @performance_metric = current_team.performance_metrics.find(params[:id])
    @performance_metric.destroy

    redirect_to performance_metrics_path
  end

  private
  def performance_metric_params
    params.require(:performance_metric).permit(:name)
  end
end