class ExpensesController < ApplicationController

  before_action :require_modal, only: [:new, :edit]

  def new
    @expense = Expense.new(user: current_user)
    @expense.event = Event.find(params[:event_id]) if params[:event_id]

    respond_to :html
  end

  def edit
    @expense = Expense.find(params[:id])

    respond_to :html
  end

  def create
    @expense = Expense.new expense_params

    authorize! @expense, :create
    if @expense.save
      redirect_to expenses_event_path(@expense.event)
    else
      render action: :new
    end
  end

  def update
    @expense = Expense.find(params[:id])

    authorize! @expense, :update
    if @expense.update_attributes expense_params
      redirect_to expenses_event_path(@expense.event)
    else
      render action: :edit
    end
  end

  def destroy
    expense = Expense.where(:id => params[:id]).first
    authorize! expense, :destroy
    expense.destroy

    redirect_to expenses_event_path(expense.event)
  end

  private
  def expense_params
    params.require(:expense).permit(:event_id, :user_id, :expense_type_id, :item_id, :count, :currency_id, :usd)
  end


end
