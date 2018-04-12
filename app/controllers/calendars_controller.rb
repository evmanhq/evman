class CalendarsController < ApplicationController

  def index
    @events = current_team.events.includes(:event_type, city: [:country, :state, :english_city_name])
    @filterer = Filterer::EventsFilterer.new(scope: @events,
                                             payload: params[:filter] || filter_bookmark_payload,
                                             current_team: current_team)
  end

  def user
    calendar = Icalendar::Calendar.new
    calendar.prodid = user_url(current_user)
    Event.where(:team => current_user.teams).joins(:users).where(:users => {:id => current_user}).order(:begins_at).all.each do |event|
      ends = event.ends_at
      ends += 1.day if ends > event.begins_at
      calendar.event do |e|
        e.dtstart       = Icalendar::Values::Date.new(event.begins_at)
        e.dtend         = Icalendar::Values::Date.new(ends)
        e.created       = event.created_at
        e.last_modified = event.updated_at
        e.summary       = event.name
        e.uid           = e.url = url_for(event)
        e.location      = event.full_location if event.respond_to?(:full_location)
      end if event.begins_at && event.ends_at
    end
    render plain: calendar.to_ical
  end

  def cfps
    calendar = Icalendar::Calendar.new
    calendar.prodid = team_url(current_team)
    Event.where(:team => current_user.teams).where('cfp_date >= (SELECT CURRENT_DATE)').order(:cfp_date).all.each do |event|
      calendar.event do |e|
        e.dtstart       = Icalendar::Values::Date.new(event.cfp_date)
        e.dtend         = Icalendar::Values::Date.new(event.cfp_date)
        e.created       = event.created_at
        e.last_modified = event.updated_at
        e.summary       = event.name
        e.uid           = e.url = url_for(event)
        e.location      = event.full_location if event.respond_to?(:full_location)
      end if event.begins_at && event.ends_at
    end
    render plain: calendar.to_ical
  end

  def user_cfps
    calendar = Icalendar::Calendar.new
    calendar.prodid = user_url(current_user)
    Event.where(:team => current_user.teams).joins(:users).where(:users => {:id => current_user}).where('cfp_date >= (SELECT CURRENT_DATE)').order(:cfp_date).all.each do |event|
      calendar.event do |e|
        e.dtstart       = Icalendar::Values::Date.new(event.cfp_date)
        e.dtend         = Icalendar::Values::Date.new(event.cfp_date)
        e.created       = event.created_at
        e.last_modified = event.updated_at
        e.summary       = event.name
        e.uid           = e.url = url_for(event)
        e.location      = event.full_location if event.respond_to?(:full_location)
      end if event.begins_at && event.ends_at
    end
    render plain: calendar.to_ical
  end

  def events
    @events = current_team.events.where(:archived => [false, nil]).includes(:event_type)
    @events = @events.where('begins_at >= ? OR ends_at >= ?', Date.parse(params[:start]), Date.parse(params[:start])) if params[:start]
    @events = @events.where('begins_at <= ? OR ends_at <= ?', Date.parse(params[:end]), Date.parse(params[:end])) if params[:end]

    @filterer = Filterer::EventsFilterer.new(scope: @events,
                                             payload: params[:filter],
                                             current_team: current_team)
    @events = @filterer.filtered
    render :json => @events.as_json(include: :event_type)
  end

end
