Given(/^"(.*)" event exists in current team$/) do |type|
  options = {
      team: current_team
  }
  case type.to_s.downcase
  when 'committed' then
    options[:committed] = true
  when 'approved' then
    options[:approved] = true
  when 'cfp deadline future' then
    options[:cfp_date] = 5.days.from_now
  when nil, '', 'normal' then
  else
    raise ArgumentError, 'unknown event type'
  end
  event = FactoryGirl.create(:event, options)
  observe_object event
end

When(/^Focused on "(.*)" panel$/) do |panel_name|
  panel = page.find ".#{panel_name}-panel"
  focus panel
end

When(/^I am attending that event/) do
  expect(observable).to be_instance_of Event
  FactoryGirl.create(:attendee, user: current_user, event: observable)
end

Then /^I should see it$/ do
  expect(focused_object).to have_content observable_content
end

Then(/^it should be written in bold$/) do
  element = focused_object.first('strong', text: observable_content)
  expect(element).to be_present
end

When(/^focused on it's continent panel$/) do
  expect(observable).to be_instance_of Event
  continent_name = observable.city.country.continent.name
  continent_panel = page.find('.continent-panel', text: continent_name)
  focus continent_panel
end