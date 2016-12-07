class TalksController < ApplicationController

  before_action :require_modal, only: [:new, :edit]

  def index
    respond_to do |format|
      format.html do
        @recent = Talk.where(:team_id => current_team.id, :archived => false).order(:created_at => :desc).limit(5).all
        @my = Talk.where(:user => current_user, :archived => false).order(:created_at => :desc).all
      end
      format.json do
        @talks = Talk.where(:team_id => current_team.id, :archived => false)
        @talks = @talks.where('LOWER(name) LIKE ? AND archived=?', "%#{params[:q][:term].downcase}%", false) if params[:q]
        render :json => @talks
      end
    end
  end

  def new
    @talk = Talk.new
    @talk.user = current_user
    @talk.event_type = current_team.default_event_type

    respond_to :html
  end

  def create
    @talk = Talk.new(talk_params)
    @talk.team = current_team
    authorize! @talk, :create

    if @talk.save
      redirect_to @talk
    else
      render action: :new
    end
  end

  def show
    @talk = Talk.find(params[:id])
    authorize! @talk, :read
  end

  def edit
    @talk = Talk.find(params[:id])
    authorize! @talk, :update
  end

  def update
    @talk = Talk.find(params[:id])
    authorize! @talk, :update

    if @talk.update_attributes talk_params
      redirect_to @talk
    else
      render action: :edit
    end
  end

  def destroy
    @talk = Talk.find(params[:id])
    authorize! @talk, :destroy
    @talk.destroy

    redirect_to(talks_path)
  end


  private
  def talk_params
    params.require(:talk).permit(:name, :abstract, :user_id, :event_type_id, :archived)
  end

end
