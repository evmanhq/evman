class TaskListsController < ApplicationController
  def edit
    @task_list = TaskList.find(params[:id])

    respond_to :html
  end

  def create
    list = TaskList.new
    list.team = current_team
    list.name = params[:task_list][:name]
    list.position = 0
    list.save

    redirect_to(tasks_path)
  end

  def destroy
    list = TaskList.find(params[:id])
    Task.destroy_all(:task_list_id => list.id)
    list.destroy
    redirect_to(tasks_path)
  end

  def update
    list = TaskList.find(params[:id])
    list.name = params[:task_list][:name]
    list.save
    redirect_to(tasks_path)
  end

end
