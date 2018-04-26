class AnnouncementsController < ApplicationController

  layout 'welcome'

  skip_before_action :announcements

  def index
    @announcement = Announcement.new_for_user(current_user).first
    redirect_to(dashboard_path) unless @announcement
  end

  def update
    @announcement = Announcement.find(params[:id])
    answer = params[:answer]
    return redirect_to announcements_path unless @announcement.answer[answer]
    AnnouncementUser.create(announcement: @announcement, user: current_user, answer: answer)
    redirect_to(dashboard_path)
  end

end
