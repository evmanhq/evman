class ProfilePicturesController < ApplicationController
  before_action :require_modal, only: [:new, :show]

  skip_before_action :authenticate!, only: [:download]
  skip_before_action :require_team!

  def toggle_public
    @profile_picture = ProfilePicture.find(params[:id])
    @profile_picture.public = !@profile_picture.public
    @profile_picture.save

    redirect_to(avatars_user_path(current_user))
  end

  def set_default
    @profile_picture = ProfilePicture.find(params[:id])
    @user = User.find(current_user.id)
    @user.default_profile_picture_id = @profile_picture.id
    @user.save

    redirect_to(avatars_user_path(current_user))
  end

  def set_gravatar
    @user = User.find(current_user.id)
    @user.default_profile_picture_id = nil
    @user.save

    redirect_to(avatars_user_path(current_user))
  end

  def show
    @profile_picture = ProfilePicture.find(params[:id])
  end

  def download
    @profile_picture = ProfilePicture.find(params[:id])
    type = params[:type] || :original
    if !@profile_picture.public? and (!current_user or current_user != @profile_picture.user)
      render plain: '', status: :unauthorized
      return
    end

    if Rails.env.development?
      data = File.read(@profile_picture.image.path(type))
      send_data data, disposition: :inline, type: @profile_picture.image.content_type
    else
      nginx_download(@profile_picture.image.url(type))
    end
  end

  def new
    @profile_picture = ProfilePicture.new

    respond_to :html
  end

  def create
    @profile_picture = ProfilePicture.new(profile_picture_params)
    @profile_picture.user_id = current_user.id

    if @profile_picture.save
      redirect_to(avatars_user_path(current_user))
    else
      render action: :new
    end
  end

  def destroy
    @profile_picture = ProfilePicture.find(params[:id])

    @profile_picture.destroy
    redirect_to(avatars_user_path(current_user))
  end

  private

  def profile_picture_params
    params.require(:profile_picture).permit(:image)
  end

end
