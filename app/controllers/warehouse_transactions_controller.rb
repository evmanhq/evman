class WarehouseTransactionsController < ApplicationController

  before_action :require_modal, only: [:new, :edit]

  def index
    @batch = WarehouseBatch.find(params[:warehouse_batch_id])
    @transactions = @batch.transactions.assignments.order(:created_at)

    respond_to :html
  end

  def new
    transaction = WarehouseTransaction.new(event_id: params[:event_id], batch_id: params[:warehouse_batch_id])
    @form = WarehouseServices::TransactionForm.new transaction

    respond_to :html
  end

  def edit
    transaction = WarehouseTransaction.find(params[:id])
    @form = WarehouseServices::TransactionForm.new transaction

    respond_to :html
  end

  def create
    @form = WarehouseServices::TransactionForm.new(WarehouseTransaction.new, transaction_params)
    if @form.submit
      redirect_back(fallback_location: @form.batch)
    else
      render action: :new
    end
  end

  def update
    transaction = WarehouseTransaction.find(params[:id])
    @form = WarehouseServices::TransactionForm.new(transaction, transaction_params)
    if @form.submit
      redirect_back(fallback_location: @form.batch)
    else
      render action: :edit
    end
  end

  def destroy
    transaction = WarehouseTransaction.find(params[:id])
    transaction.destroy

    redirect_back(fallback_location: transaction.batch)
  end

  private
  def transaction_params
    params.require(:warehouse_transaction).permit(*WarehouseServices::TransactionForm::ATTRIBUTES)
  end
end