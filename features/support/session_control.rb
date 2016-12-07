module SessionControl
  def current_user
    raise StandardError, 'no current user' if @current_user.blank?
    @current_user
  end

  def current_team
    raise StandardError, 'no current team' if @current_team.blank?
    @current_team
  end
end