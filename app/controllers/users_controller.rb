class UsersController < ApplicationController

  skip_before_action :validate_user_info!, :only => [:edit, :update]
  skip_before_action :require_team!

  def dump
    @user = User.find(params[:id])
    authorize! @user, :dump

    render json: @user, serializer: UserDumpSerializer
  end

  def index
    respond_to do |format|
      format.json do
        render :json => User.find(current_user.id)
      end
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! @user, :read
    @providers = @user.identities.pluck(:provider)

    respond_to do |format|
      format.json do
        render :json => @user
      end
      format.html do
        @invitations = TeamInvitation.where(:email => current_user.emails.pluck(:email), :accepted => nil).all
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize! @user, :update
  end

  def update
    @user = User.find(params[:id])
    authorize! @user, :update
    p = user_params
    p.delete(:password) if p[:password].blank?
    
    @user.attributes = p
    @user.save
    redirect_to(user_path(@user))
  end

  def avatars
    @user = User.find(params[:id])
  end

  def biographies
    @user = User.find(params[:id])
    @biographies = @user.biographies.order(:name)
  end

  def calendars
    @user = User.find(params[:id])
    authorize! @user, :signed_in?
  end

  private
  def user_params
    params.require(:user).permit(:name, :job_title, :organization, :home_country_id, :phone, :twitter, :github, :password)
  end

end