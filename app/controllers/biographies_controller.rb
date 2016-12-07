class BiographiesController < ApplicationController

  skip_before_action :require_team!

  def set_default
    @biography = Biography.find(params[:id])
    @user = User.find(current_user.id)
    @user.default_biography_id = @biography.id
    @user.save

    redirect_to(biographies_user_path(current_user))
  end

  def new
    @biography = Biography.new
    respond_to :html
  end

  def edit
    @biography = Biography.find(params[:id])
    respond_to :html
  end

  def create
    @biography = Biography.new(biography_params)
    @biography.user_id = current_user.id

    if @biography.save
      redirect_to(biographies_user_path(current_user))
    else
      render action: :new
    end
  end

  def update
    @biography = Biography.find(params[:id])

    if @biography.update_attributes(biography_params)
      redirect_to(biographies_user_path(current_user))
    else
      render action: :edit
    end
  end

  def destroy
    @biography = Biography.find(params[:id])
    @biography.destroy

    redirect_to(biographies_user_path(current_user))
  end

  private

  def biography_params
    params.require(:biography).permit(:name, :content)
  end

end
