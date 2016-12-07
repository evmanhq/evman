Then(/^I should see approved status$/) do
  event = observable
  on(Pages::Events::ShowPage) do |po|
    po.expect_button_status po.approved_button, event.approved
  end
end

Then(/^I should see committed status$/) do
  event = observable
  on(Pages::Events::ShowPage) do |po|
    po.expect_button_status po.committed_button, event.committed
  end
end

Then(/^I should see archived status$/) do
  event = observable
  on(Pages::Events::ShowPage) do |po|
    if event.archived
      po.expect_to_be_archived
    else
      po.expect_not_to_be_archived
    end
  end
end

When(/^I click on address button$/) do
  on(Pages::Events::ShowPage) do |po|
    po.map_link.click
  end
end

And(/^I submit new note form$/) do
  on(Pages::Events::ShowPage) do |po|
    po.submit_new_note_form
  end
end

Then(/^I should see last note content$/) do
  expect(page).to have_content EventNote.last.content
end

When(/^I submit add attendee form$/) do
  on(Pages::Events::ShowPage) do |po|
    po.submit_add_attendee_form user_id: current_user.id
  end
end

Then(/^I should see new attendee$/) do
  on(Pages::Events::ShowPage) do |po|
    expect(po.attendee_avatar(current_user)).to be_present
  end
end

When(/^I submit new event talk form$/) do
  @talk = FactoryGirl.create :talk, user: current_user, team: current_team
  event = observable
  on(Pages::Events::ShowPage) do |po|
    po.submit_new_event_talk_form user_id:  current_user.id,
                                  talk_name:  @talk.name,
                                  event_id: event.id
  end
end

Then(/^I should see new talk in the event$/) do
  on(Pages::Events::ShowPage) do |po|
    expect(po.talks_container).to have_content @talk.name
  end
end