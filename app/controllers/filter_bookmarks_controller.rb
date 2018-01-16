class FilterBookmarksController < ApplicationController

  before_action :require_modal, only: [:show, :new, :edit]
  skip_before_action :authenticate!, only: [:link]

  def link
    filter_bookmark = FilterBookmark.find_by(code: params[:code])
    unless filter_bookmark
      render text: 'not found'
      return
    end
    authorize! filter_bookmark, :read
    link = filter_bookmark.filterer_class.links.find do |link|
      link.name == params[:link]
    end

    paths = link.paths(filter_bookmark)

    if current_user
      redirect_to paths.private_path
    else
      redirect_to paths.public_path
    end
  end

  def index
    @my = current_team.filter_bookmarks.merge(current_user.filter_bookmarks).order(:name)
    @public = current_team.filter_bookmarks.where('owner_id != ?', current_user.id).where(public: true).order(:name)

    respond_to :html
  end

  def show
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :read
  end

  def new
    constrains = params[:constrains] || []
    sort_rules = params[:sort_rules] || []
    @filter_bookmark = current_team.filter_bookmarks.build(
        filterer_name: 'EventsFilterer',
        owner: current_user,
        payload: { constrains: constrains, sort_rules: sort_rules }
    )

    respond_to :html
  end

  def edit
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :update

    respond_to :html
  end

  def create
    @filter_bookmark = current_team.filter_bookmarks.build(filter_bookmark_params)
    authorize! @filter_bookmark, :create

    if @filter_bookmark.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :update

    if @filter_bookmark.update_attributes(filter_bookmark_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :destroy
    @filter_bookmark.destroy

    redirect_to action: :index
  end

  private
  def filter_bookmark_params
    params.require(:filter_bookmark).permit(:name, :public, :owner_id, :filterer_name,
                                            payload: { constrains: [:name, :condition, values: []],
                                                       sort_rules: [:name, :direction]
                                            })
  end

end
