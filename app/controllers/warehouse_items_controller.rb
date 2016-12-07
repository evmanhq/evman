class WarehouseItemsController < ApplicationController
  before_action :find_warehouse, only: [:index, :new]
  before_action :require_modal, only: [:new, :edit]

  def index
    @items = @warehouse.items.order(:name)
    @counts = WarehouseBatch.where(item_id: @items.select(:id)).group(:item_id).sum(:total)
  end

  def show
    redirect_to warehouse_item_warehouse_batches_path(params[:id])
  end

  def new
    @item = @warehouse.items.build

    respond_to :html
  end

  def create
    @item = WarehouseItem.new(item_params)

    if @item.save
      redirect_to @item.warehouse
    else
      render action: :new
    end
  end

  def edit
    @item = WarehouseItem.find(params[:id])

    respond_to :html
  end

  def update
    @item = WarehouseItem.find(params[:id])
    @item.attributes = item_params

    if @item.save
      redirect_to @item.warehouse
    else
      render action: :edit
    end
  end

  def destroy
    @item = WarehouseItem.find(params[:id])
    @item.destroy

    redirect_to @item.warehouse
  end

  private
  def item_params
    params.require(:warehouse_item).permit(:name, :warehouse_id)
  end

  def find_warehouse
    @warehouse = current_team.warehouses.find(params[:warehouse_id])
  end
end
