When(/^Event associations are bootstraped$/) do
  @bootstrap_data = {
      event_type: FactoryGirl.create(:event_type, team: current_team),
      city: FactoryGirl.create(:city)
  }
end

When(/^I fill event form$/) do
  @event_count_before = Event.count
  @data = {
      name: 'Arbitrary event name',
      location: 'Arbitrary event location',
      url: 'http://some.conference-site.com',
      sponsorship: 'Arbitrary sponsorship',
      sponsorship_date: 5.days.from_now.to_date,
      cfp_url: 'http://some.conference-site.com/cfp',
      cfp_date: 10.days.from_now.to_date,
      begins_at: 15.days.from_now.to_date,
      ends_at: 17.days.from_now.to_date,
      owner_id: current_user.id,
      event_type_id: @bootstrap_data[:event_type].id,
      city_id: @bootstrap_data[:city].id,
  }

  @data.each do |attr, value|
    case attr
    when :city_id
      select2 "event[#{attr}]", search: @bootstrap_data[:city].display, wait_for_request: 0.3
    when :owner_id, :event_type_id
      fill_dynamic_select "event[#{attr}]", with: value
    else
      fill_in "event[#{attr}]", with: value
    end
  end
end

Then(/^I should see events form$/) do
  form = page.find('form')
  expect(form).to be_present
  expect(form).to have_field 'event[name]'
  expect(form).to have_field 'event[event_type_id]'
  expect(form).to have_field 'event[city_id]'
  expect(form).to have_field 'event[location]'
  expect(form).to have_field 'event[url]'
  expect(form).to have_field 'event[sponsorship]'
  expect(form).to have_field 'event[sponsorship_date]'
  expect(form).to have_field 'event[cfp_url]'
  expect(form).to have_field 'event[cfp_date]'
  expect(form).to have_field 'event[begins_at]'
  expect(form).to have_field 'event[ends_at]'
  expect(form).to have_field 'event[owner_id]'
end

Then(/^Event should be saved$/) do
  event = Event.last
  expect(event).to be_instance_of Event
  @data.each do |attr, value|
    expect(event.send(attr)).to eql(value), "attribute #{attr} should be #{value.inspect} but is #{event.send(attr).inspect}"
  end
end

Then(/^Event should be updated$/) do
  expect(Event.count).to eql(@event_count_before)
  step 'Event should be saved'
end

When(/^I submit event form$/) do
  click_button 'Save'
  wait_for_ajax
end

Then(/^I should see new event modal$/) do
  expect(page).to have_content 'New event'
  step 'I should see events form'
end

When(/^Example event exists and observed$/) do
  observe_object FactoryGirl.create(:event, team: @current_team)
end

Then(/^I should see edit event modal$/) do
  expect(page).to have_content 'Edit event'
  step 'I should see events form'
end