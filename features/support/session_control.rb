module SessionControl
  def current_user
    raise StandardError, 'no current user' if @current_user.blank?
    @current_user
  end

  def current_team
    raise StandardError, 'no current team' if @current_team.blank?
    @current_team
  end

  def determine_current_user
    user_id = page.driver.cookies['user_id'].try(:value)
    @current_user = User.where(id: user_id).first if user_id
  end
end