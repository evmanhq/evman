class FilterBookmarksController < ApplicationController

  before_action :require_modal, only: [:show, :new, :edit]

  def link
    filter_bookmark = FilterBookmark.find_by(code: params[:code])
    link = filter_bookmark.filterer_class.links.find do |link|
      link.name == params[:link]
    end
    redirect_to link.path(filter_bookmark)
  end

  def index
    @my = current_team.filter_bookmarks.merge(current_user.filter_bookmarks).order(:name)
    @public = current_team.filter_bookmarks.where('owner_id != ?', current_user.id).where(public: true).order(:name)

    respond_to :html
  end

  def new
    constrains = params[:constrains] || []
    @filter_bookmark = current_team.filter_bookmarks.build(
        filterer_name: 'EventsFilterer',
        owner: current_user,
        payload: { constrains: constrains }
    )
    @filterer = derive_filterer(@filter_bookmark)
    respond_to :html
  end

  def edit
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :update
    @filterer = derive_filterer(@filter_bookmark)

    respond_to :html
  end

  def create
    @filter_bookmark = current_team.filter_bookmarks.build(filter_bookmark_params)
    authorize! @filter_bookmark, :create
    @filterer = derive_filterer(@filter_bookmark)
    if @filter_bookmark.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    @filter_bookmark = current_team.filter_bookmarks.find(params[:id])
    authorize! @filter_bookmark, :update
    @filterer = derive_filterer(@filter_bookmark)
    if @filter_bookmark.update_attributes(filter_bookmark_params)
      redirect_to action: :index
    else
      render action: :new
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
                                            payload: { constrains: [:name, :condition, values: []] })
  end

  def derive_filterer(filter_bookmark)
    filterer = filter_bookmark.filterer(current_team)
    return nil unless filterer
    filterer.set_ui_options({ record_name: 'filter_bookmark[payload]', show_submit: false })
    filterer
  end

end
