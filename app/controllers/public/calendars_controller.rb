module Public
  class CalendarsController < BaseController
    def index
      filter_bookmark = FilterBookmark.where(code: params[:filter_bookmark_code]).first
      unless filter_bookmark
        redirect_to root_path
        return
      end
      authorize! filter_bookmark, :read
      @team = filter_bookmark.team
    end

    def events
      filter_bookmark = FilterBookmark.where(code: params[:filter_bookmark_code]).first
      unless filter_bookmark
        redirect_to root_path
        return
      end
      authorize! filter_bookmark, :read

      scope = filter_bookmark.team.events.where(:archived => [false, nil]).includes(:event_type)
      scope = scope.where('begins_at >= ? OR ends_at >= ?', Date.parse(params[:start]), Date.parse(params[:start])) if params[:start]
      scope = scope.where('begins_at <= ? OR ends_at <= ?', Date.parse(params[:end]), Date.parse(params[:end])) if params[:end]

      filterer = filter_bookmark.filterer(scope: scope)
      render :json => filterer.filtered.as_json(include: :event_type)
    end
  end
end