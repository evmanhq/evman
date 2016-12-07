class EventsController < ApplicationController

  before_action :require_modal, only: [:new, :edit, :add_attendee]

  def add_attendee
    @attendee = Attendee.new
    @attendee.user = current_user
    @attendee.attendee_type = current_team.default_attendee_type
    @attendee.event_id = params[:id]

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
        @base = @base.where('begins_at >= ? OR ends_at >= ?', Date.parse(params['start']), Date.parse(params['start'])) if params['start']
        @base = @base.where('begins_at <= ? OR ends_at <= ?', Date.parse(params['end']), Date.parse(params['end'])) if params['end']
        @base = @base.where('LOWER(name) LIKE ?', "%#{params[:q][:term].downcase}%") if params['q']
        render :json => @base.all
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
        :event_type_id,
        :approved,
        :committed,
        :archived,
        :city_id,
        :location,
        :url,
        :sponsorship,
        :sponsorship_date,
        :cfp_url,
        :cfp_date,
        :begins_at,
        :ends_at,
        :owner_id

    )
  end
end
