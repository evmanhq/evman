class CalendarsController < ApplicationController

  def index
  end

  def user
    calendar = Icalendar::Calendar.new
    calendar.prodid = user_url(current_user)
    Event.where(:team => current_user.teams).joins(:users).where(:users => {:id => current_user}).order(:begins_at).all.each do |event|
      calendar.event do |e|
        e.dtstart       = Icalendar::Values::Date.new(event.begins_at)
        e.dtend         = Icalendar::Values::Date.new(event.ends_at)
        e.created       = event.created_at
        e.last_modified = event.updated_at
        e.summary       = event.name
        e.uid           = e.url = url_for(event)
        e.location      = event.full_location if event.respond_to?(:full_location)
      end if event.begins_at && event.ends_at
    end
    render  :text => calendar.to_ical
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
    render  :text => calendar.to_ical
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
    render  :text => calendar.to_ical
  end

end
