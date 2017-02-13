When /^I am on the "(.+)" page/ do |page_name|
  case page_name
  when 'login'
    visit root_path
  when 'events'
    visit events_path
  when 'new events'
    visit new_event_path
  when 'event'
    visit event_path(Event.first)
  when 'event expenses'
    visit expenses_event_path(observable)
  when 'edit event'
    visit edit_event_path(Event.first)
  when 'dashboard'
    visit dashboard_path
  when 'profile'
    visit user_path(current_user)
  when 'invitation'
    raise StandardError, 'no invitation found' unless @invitation
    visit root_path(invitation: @invitation.code)
  end
end