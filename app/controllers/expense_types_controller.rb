class ExpenseTypesController < ApplicationController

  def create
    @expense_type = ExpenseType.new
    @expense_type.name = params[:name]
    @expense_type.team = current_team
    authorize! @expense_type, :create
    @expense_type.save

    redirect_to(settings_team_path(current_team))
  end

  def default
    @expense_type = ExpenseType.find(params[:expense_type_id])

    ExpenseType.where(:team_id => current_team.id).update_all(:default => false)

    authorize! @expense_type, :update
    @expense_type.default = true
    @expense_type.save

    redirect_to(settings_team_path(current_team))
  end

  def destroy
    @expense_type = ExpenseType.find(params[:id])
    return redirect_to(settings_team_path(current_team)) if @expense_type.default

    authorize! @expense_type, :destroy
    @expense_type.destroy

    Expense.where(:expense_type_id => params[:id]).update_all(:expense_type_id => current_team.default_attendee_type)

    redirect_to(settings_team_path(current_team))
  end

end
