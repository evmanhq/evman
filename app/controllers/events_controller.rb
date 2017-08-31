class EventsController < ApplicationController

  before_action :require_modal, only: [:new, :edit, :add_attendee]

  EXPORT_FIELDS = %w(name committed approved archived city location url sponsorship sponsorship_date cfp_url cfp_date
                     begins_at ends_at owner event_type created_at updated_at)

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
                                             payload: params[:filter],
                                             current_team: current_team)
    @events = @filterer.filtered
    @events = @events.page(params[:page] || 1).per(50)

    respond_to :html
  end

  def index
    @base = current_team.events.where(:archived => [false, nil])

    respond_to do |format|
      format.html do
        @base = @base.where('begins_at >= ? OR ends_at >= ?', Date.today, Date.today)

        @base = @base.includes(:users, :event_talks, :team)

        @committed = @base.where(:committed => true).includes(:expenses, :talks).order(:begins_at => :asc).all
        @tracked = @base.where(:committed => [nil, false]).order(:begins_at => :asc).all
        @talks = @base.where('cfp_date >= ?', Date.today).order(:cfp_date => :asc).all

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

  def attachments
    @event = Event.find(params[:id])
    authorize! @event, :read
  end

  def create
    @event = Event.new(event_params)
    @event.team = current_team
    authorize! @event, :create

    if @event.save
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
    @event.approved = !@event.approved
    @event.save
    redirect_to(event_path(@event))
  end

  def committed
    @event = Event.find(params[:id])
    authorize! @event, :update
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
    @fields = EXPORT_FIELDS
  end

  def generate_export
    params[:field] ||= []

    @fields = (params[:field] - (params[:field] - EXPORT_FIELDS))
    @events = current_team.events

    if params[:archived] && params[:archived] != ''
      @events = @events.where('archived = ? OR ends_at < NOW()', params[:archived])
    end

    if params[:from_date] && params[:from_date] != ''
      @events = @events.where('begins_at > ?', DateTime.parse(params[:from_date]))
    end

    if params[:until_date] && params[:until_date] != ''
      @events = @events.where('ends_at < ?', DateTime.parse(params[:until_date]))
    end

    if params[:city_id] && params[:city_id] != ''
      @events = @events.where(city_id: params[:city_id])
    end

    if params[:country_id] && params[:country_id] != ''
      @events = @events.joins(:city => :country).where(countries: { id: params[:country_id]})
    end

    if params[:continent_id] && params[:continent_id] != ''
      @events = @events.joins(:city => { country: :continent}).where(continents: { id: params[:continent_id]})
    end

    if params[:committed] && params[:committed] != ''
      @events = @events.where(committed: params[:committed])
    end

    if params[:approved] && params[:approved] != ''
      @events = @events.where(approved: params[:approved])
    end

    if params[:event_type_id] && params[:event_type_id] != ''
      @events = @events.where(event_type_id: params[:event_type_id])
    end

    @events = @events.includes(:city => :city_names).all

    authorize! @events, :read

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => 'Events') do |sheet|
        sheet.add_row(@fields.map { |field| field.humanize })
        @events.each do |event|
          sheet.add_row(@fields.map do |field|
            value = event.send(field)
            value = 'YES' if value.kind_of?(TrueClass)
            value = nil if value.kind_of?(FalseClass)
            value = value.to_s if value.kind_of?(City)
            value = value.name if value.respond_to?(:name)
            value
          end)
        end
      end

      data = p.to_stream.string
      render body: data, content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
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
