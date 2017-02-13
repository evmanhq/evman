Given /^I am not logged in/ do

end

Then /^I should see "(.*)"$/ do |content|
  binding.pry if @use_pry
  expect(page).to have_content content
end

Given /^Oauth mock is set:$/ do |table|
  @uid, @provider, @name, @email = table.rows.first
  OmniAuth.config.add_mock(@provider.to_sym, {
      uid: @uid,
      info: {
          name: @name,
          email: @email
      },
      credentials: {
          token: 'token1234',
          secret: 'secret1234'
      }
  })

  OmniAuth.config.test_mode = true
end

Given /^User with identity exists ?(.*):$/ do |options, table|
  login = (options == 'and logged in')

  uid, provider, name, email = table.rows.first
  user = FactoryGirl.create :user, name: name, email: email
  user.identities.create!(provider: provider, uid: uid)
  user.add_email(email)
  @registered_user = user

  if login
    page.driver.set_cookie :user_id, user.id, path: '/', domain: '127.0.0.1'
    @current_user = user
  end
end

Then /^I should not be logged in$/ do
  determine_current_user
  expect(@current_user).not_to be_present
end

Then /^I should be logged in as new user$/ do
  wait_for_ajax
  determine_current_user
  expect(current_user).to be_present

  expect(current_user.name).to eql(@name)
  expect(current_user.email).to eql(@email)

  user_email = current_user.emails.where(email: @email).first
  expect(user_email).to be_present
end

Then /^I should be logged in as existing user$/ do
  wait_for_ajax
  determine_current_user
  expect(current_user).to eql(@registered_user)
end

Then /^Current user should have emails:$/ do |table|
  wait_for_ajax
  table.rows.each do |email|
    expect(current_user.emails.where(email: email)).to exist
  end
end

Then /^Current user should have identities:$/ do |table|
  table.rows.each do |row|
    uid, provider = row
    expect(current_user.identities.where(uid: uid, provider: provider)).to exist
  end
end

When /^Team with email domain "(.*)" exists$/ do |domain|
  @team = FactoryGirl.create :team, email_domain: domain
end

Then /^I should be in a team$/ do
  expect(current_user.teams).to include @team
end

Given /^Evman requires invitation$/ do
  ENV['EVMAN_REQUIRE_INVITATION'] = 'true'
end

Given /^Invitation exists$/ do
  @invitation = FactoryGirl.create :team_invitation, email: 'john@github.com'
  @team = @invitation.team
end