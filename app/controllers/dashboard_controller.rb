class DashboardController < ApplicationController

  def index
    @events = current_user.events.where(archived: [nil, false])
                  .where('begins_at >= ? OR ends_at >= ?', DateTime.now, DateTime.now).map do |event|
      [:event, event.begins_at, event]
    end

    @events += current_user.events.where(archived: [nil, false]).where('cfp_date >= ?', DateTime.now).map do |event|
      [:cfp, event.cfp_date, event]
    end
    
    @events = @events.sort_by { |item| item[1] }

    @invitations = TeamInvitation.where(:email => current_user.emails.pluck(:email), :accepted => nil).all
  end

end
