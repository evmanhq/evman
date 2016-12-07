class TagsController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        tags = current_team.tags.where('lower(name) LIKE ?', "#{params[:q].downcase}%").all.map do |tag|
          {:id => tag.id, :text => tag.name}
        end
        render :json => tags
      end
      format.html do
        @counts = Tagged.joins(:tag).where(tags: { team_id: current_team.id }).group(:tag_id).count
        @populate_form = TagServices::PopulateForm.new({}, current_team)
        @tags = current_team.tags.order(name: :asc)
      end
    end
  end

  def populate
    @populate_form = TagServices::PopulateForm.new populate_params, current_team
    @populate_form.submit
    redirect_to action: :index
  end

  def new
    @tag = Tag.new

    respond_to :html
  end

  def create
    @tag = Tag.new
    authorize! @tag, :create
    @tag.name = params[:tag][:name]
    @tag.keyword = params[:tag][:name].downcase
    @tag.team = current_team
    if @tag.save
      redirect_to(tags_path)
    else
      render action: :new
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize! @tag, :destroy
    @tag.destroy

    redirect_to(tags_path)
  end

  private

  def populate_params
    params.require(:populate_form).permit(tag_names: [])
  end

end
