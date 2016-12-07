class TasksController < ApplicationController

  def index
    @lists = current_team.task_lists.includes(:tasks).all
  end

  def show
    @task = Task.find(params[:id])
    respond_to :html
  end

  def create
    task = Task.new
    task.name = params[:task][:name]
    task.task_list = TaskList.find(params[:task][:task_list_id])
    task.save

    redirect_to(tasks_path)
  end

  def update
    task = Task.find(params[:id])
    task.name = params[:task][:name]
    task.due = params[:task][:due]
    task.description = params[:task][:description]
    task.save
    redirect_to(tasks_path)
  end

  def move
    task = Task.find(params[:task_id])
    task.task_list = TaskList.find(params[:task_list_id])
    task.save!
    render json: task
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to(tasks_path)
  end

end
