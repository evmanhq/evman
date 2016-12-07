When /^I click on "(.+)"$/ do |link_name|
  click_link link_name
end

When /^Focused on "(.*)"$/ do |css_selector|
  focus page.find(css_selector)
end