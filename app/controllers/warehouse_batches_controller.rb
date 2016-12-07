class WarehouseBatchesController < ApplicationController
  before_action :find_item, only: [:new, :index]
  before_action :require_modal, only: [:new, :edit]

  def autocomplete
    tokens = params[:q][:term].to_s.split(/ +/)
    @batches = WarehouseBatch.includes(:item).references(:item).where( warehouse_items: {
        warehouse_id: current_team.warehouses.select(:id)
    })
    tokens.each do |token|
      @batches = @batches.where("warehouse_items.name ILIKE ? OR warehouse_batches.price = ?", "%#{token}%", token.to_d)
    end

    @batches = @batches.where("warehouse_batches.total > 0") if params[:only_available].present?

    @batches = @batches.limit(150)
    @batches = @batches.all.collect{|b| { id: b.id, label: b.label } }

    respond_to do |format|
      format.json { render json: @batches }
    end
  end

  def index
    @batches = @item.batches.includes(:initial_transaction).order('created_at DESC')
  end

  def show
    redirect_to warehouse_batch_warehouse_transactions_path(params[:id])
  end

  def new
    batch = @item.batches.build
    @batch_form = WarehouseServices::BatchForm.new batch, item_id: @item.id

    respond_to :html
  end

  def create
    batch = WarehouseBatch.new
    @batch_form = WarehouseServices::BatchForm.new batch, batch_params

    if @batch_form.submit
      redirect_to batch.item
    else
      render action: :new
    end
  end

  def edit
    batch = WarehouseBatch.find(params[:id])
    @batch_form = WarehouseServices::BatchForm.new batch

    respond_to :html
  end

  def update
    batch = WarehouseBatch.find(params[:id])
    @batch_form = WarehouseServices::BatchForm.new batch, batch_params

    if @batch_form.submit
      redirect_to batch.item
    else
      render action: :edit
    end
  end

  def destroy
    batch = WarehouseBatch.find(params[:id])
    batch.destroy

    redirect_to batch.item
  end

  private
  def batch_params
    params.require(:warehouse_batch).permit(:price, :count, :item_id)
  end

  def find_item
    @item = WarehouseItem.find(params[:warehouse_item_id])
  end
end
