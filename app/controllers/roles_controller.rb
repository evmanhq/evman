class RolesController < ApplicationController

  before_action :require_modal, only: [:new, :edit, :edit_user_roles]

  before_action do |controller|
    controller.can! :role, :read
  end

  before_action only: [:update_user_roles, :set_default, :create, :update, :destroy] do |controller|
    controller.can! :role, :manage
  end

  def edit_user_roles
    @user = current_team.users.find(params[:user_id])

    respond_to :html
  end

  def update_user_roles
    @user = current_team.users.find(params[:user_id])
    @user.update_attributes(params.require(:user).permit(role_ids: []))

    redirect_to roles_path
  end

  def index
    @roles = current_team.roles.order(default: :desc, name: :asc)
    @users = current_team.users.includes(:roles).uniq

    respond_to :html
  end

  def new
    @role = current_team.roles.build

    respond_to :html
  end

  def edit
    @role = current_team.roles.find(params[:id])

    respond_to :html
  end

  def set_default
    @role = current_team.roles.find(params[:id])
    Role.transaction do
      current_team.roles.where(default: true).update_all(default: false)
      @role.default = true
      @role.save!
    end
  rescue ActiveRecrod::RecordInvalid => _
  ensure
    redirect_to roles_path
  end

  def create
    @role = current_team.roles.build role_params
    @role.authorization_profile = Authorization::Profile.new(params[:role][:authorization_profile])

    if @role.save
      redirect_to roles_path
    else
      render action: :edit
    end
  end

  def update
    @role = current_team.roles.find(params[:id])
    @role.attributes = role_params
    @role.authorization_profile = Authorization::Profile.new(params[:role][:authorization_profile])

    if @role.save
      redirect_to roles_path
    else
      render action: :edit
    end
  end

  def destroy
    @role = current_team.roles.find(params[:id])
    @role.destroy

    redirect_to roles_path
  end

  private
  def role_params
    params.require(:role).permit(:name, :default)
  end
end
