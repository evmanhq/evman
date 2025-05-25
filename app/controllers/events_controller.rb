class EventsController < ApplicationController

  before_action :require_modal, only: [:add_attendee]
  before_action :ensure_event_team, only: [:show, :edit]

  def add_attendee
    @attendee = Attendee.new
    @attendee.user = current_user
    @attendee.attendee_type = current_team.default_attendee_type
    @attendee.event_id = params[:id]

    respond_to :html
  end

  def list
    @events = current_team.events.includes(:event_type, city: [:country, :state, :english_city_name])
    @filterer = Filterer::EventsFilterer.new(scope: @events,
                                             payload: params[:filter] || filter_bookmark_payload,
                                             current_team: current_team)
    @events = @filterer.filtered
    @events = @events.page(params[:page] || 1).per(50)

    respond_to :html
  end

  def index
    @base = current_team.events.unarchived

    respond_to do |format|
      format.html do
        @base = @base.actual
        @base = @base.includes(:users, :event_talks, :team)

        @committed = @base.committed.includes(:expenses, :talks)
        @tracked = @base.tracked
        @talks = @base.within_cfp_deadline


        @continents = {}

        Continent.all.each do |continent|
          Event.joins(:city => { :country => :continent }).where(:continents => { :id => continent.id })
              .where('events.begins_at >= ?', Date.today).where(:events => { :team_id => current_team, :archived => [false, nil] })
              .order(:begins_at).limit(5).each do |e|
            (@continents[continent] ||= []) << e
          end
        end

        authorize! @commited, :read
        authorize! @tracked, :read
        authorize! @talks, :read
      end

      format.json do
        @base = @base.includes(:event_type)
        @base = @base.where('begins_at >= ? OR ends_at >= ?', Date.parse(params['start']), Date.parse(params['start'])) if params['start']
        @base = @base.where('begins_at <= ? OR ends_at <= ?', Date.parse(params['end']), Date.parse(params['end'])) if params['end']
        @base = @base.where('LOWER(name) LIKE ?', "%#{params[:q][:term].downcase}%") if params['q']
        render :json => @base.as_json(include: :event_type)
      end
    end
  end

  def archive
    @events = current_team.events.where("archived='t' OR ends_at <= NOW()").order(:begins_at => :desc).all
  end

  def new
    @event = Event.new
    @event.team = current_team
    @event.owner = current_user
    @event.event_type = current_team.default_event_type

    authorize! @event, :create
  end

  def show
    @note = EventNote.new
    @event = Event.find(params[:id])
    authorize! @event, :read
  end

  def expenses
    @event = Event.find(params[:id])
    @expenses = @event.expenses.order(:created_at)
    @warehouse_transactions = @event.warehouse_transactions.with_price.order(:created_at)
    @sums = {}
    @sums[:expenses] = @expenses.sum(:usd)
    @sums[:transactions] = @warehouse_transactions.sum("- warehouse_transactions.total * price")
    @sums[:total] = @sums[:expenses] + @sums[:transactions]

    authorize! @event, :read
  end

  def sharing
    @event = Event.find(params[:id])
    return redirect_to event_path(@event) unless @event.team == current_team
    authorize! @event, :update
    @shares = TeamEvent.where(event: @event)
    @shared_with = @shares.map { |it| it.team }
  end

  def attachments
    @event = Event.find(params[:id])
    @attachment = Attachment.new(parent_type: 'Event', parent_id: @event.id)

    authorize! @event, :read
  end

  def create
    @event = Event.new(event_params)
    @event.team = current_team
    authorize! @event, :create

    if @event.save
      TeamEvent.create(team: current_team, event: @event)
      redirect_to @event
    else
      render action: :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    authorize! @event, :update
  end

  def approved
    @event = Event.find(params[:id])
    authorize! @event, :update
    authorize! @event, :approve
    @event.approved = !@event.approved
    @event.save
    redirect_to(event_path(@event))
  end

  def committed
    @event = Event.find(params[:id])
    authorize! @event, :update
    authorize! @event, :commit
    @event.committed = !@event.committed
    @event.save
    redirect_to(event_path(@event))
  end

  def archived
    @event = Event.find(params[:id])
    authorize! @event, :update
    @event.archived = !@event.archived
    @event.save
    redirect_to(event_path(@event))
  end

  def update
    @event = Event.find(params[:id])
    authorize! @event, :update

    if @event.update_attributes event_params
      redirect_to @event
    else
      render action: :edit
    end
  end

  def export
    @filterer = Filterer::EventsFilterer.new(current_team: current_team, payload: params[:filter] || filter_bookmark_payload)
    @exporter = EventServices::Exporter.new(current_team)
  end

  def generate_export
    @events = current_team.events
    @filterer = Filterer::EventsFilterer.new(scope: @events,
                                             payload: params[:filter],
                                             current_team: current_team)
    @events = @filterer.filtered
    @exporter = EventServices::Exporter.new(current_team, params[:exporter])

    if @exporter.valid?
      result = @exporter.export(@events)
      send_data result.data, content_type: result.content_type, filename: result.filename
    else
      render action: :export
    end
  end

  def destroy
    event = Event.where(:id => params[:id]).first

    authorize! event, :destroy

    if event.archived
      event.destroy
      redirect_to(events_path)
    else
      event.archived = true
      event.save
      redirect_to(event_path(event))
    end
  end

  private

  def ensure_event_team
    event = Event.find(params[:id])
    return true unless authorized?(event, :read)
    unless event.teams.include?(current_team)
      redirect_to event_url(event, subdomain: event.team.subdomain)
      return false
    end
    true
  end

  def event_params
    params.require(:event).permit(
        :name,
        :description,
        :event_type_id,
        :approved,
        :committed,
        :archived,
        :city_id,
        :location,
        :url,
        :url2,
        :url3,
        :sponsorship,
        :sponsorship_date,
        :cfp_url,
        :cfp_date,
        :begins_at,
        :ends_at,
        :owner_id,
        properties_assignments: {}
    )
  end
end
