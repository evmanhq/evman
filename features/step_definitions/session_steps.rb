Given /^I am logged in as user with (.+)/ do |permissions|
  case permissions
  when 'all permissions'
    profile = Authorization::Profile.new
    profile.allow_all
  else
    profile = Authorization::Profile.new
  end

  Team.where(:name => 'Public').first_or_create
  Team.where(:name => 'Members').first_or_create

  team = FactoryGirl.create :team
  role = FactoryGirl.create :role, team: team, authorization_profile: profile
  user = FactoryGirl.create :user, teams: [team], roles: [role]

  page.driver.set_cookie :user_id, user.id, path: '/', domain: '127.0.0.1'
  page.driver.set_cookie :team_id, team.id, path: '/', domain: '127.0.0.1'

  @current_user = user
  @current_team = team
end

When /^Use PRY$/ do
  @use_pry = true
end