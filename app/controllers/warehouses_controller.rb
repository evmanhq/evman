class WarehousesController < ApplicationController
  before_action :require_modal, only: [:new, :edit]

  def index
    @warehouses = current_team.warehouses.order(:name)
  end

  def show
    redirect_to warehouse_warehouse_items_path(params[:id])
  end

  def new
    @warehouse = current_team.warehouses.build

    respond_to :html
  end

  def create
    ret = Warehouse.transaction do
      @warehouse = current_team.warehouses.build(warehouse_params)
      @warehouse.teams << current_team
      @warehouse.save!
      true
    end

    if ret
      redirect_to warehouses_path
    else
      render action: :new
    end
  rescue ActiveRecord::RecordInvalid => e
    render action: :new
  end

  def edit
    @warehouse = current_team.warehouses.find(params[:id])

    respond_to :html
  end

  def update
    @warehouse = current_team.warehouses.find(params[:id])
    @warehouse.attributes = warehouse_params

    if @warehouse.save
      redirect_to warehouses_path
    else
      render action: :edit
    end
  end

  def destroy
    @warehouse = current_team.warehouses.find(params[:id])
    @warehouse.destroy

    redirect_to warehouses_path
  end

  private
  def warehouse_params
    params.require(:warehouse).permit(:name)
  end
end
