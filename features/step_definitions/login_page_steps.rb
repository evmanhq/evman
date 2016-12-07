Given /^I am not logged in/ do

end

Then /^I should see "(.*)"$/ do |content|
  binding.pry if @use_pry
  expect(page).to have_content content
end