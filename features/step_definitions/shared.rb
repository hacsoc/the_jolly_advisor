Given(/^I have authenticated as (.*)$/) do |case_id|
  @current_user =
    if case_id == 'some user'
      # We don't care about the case id, here
      User.first || FactoryGirl.create(:user)
    else
      User.where(case_id: case_id).first || FactoryGirl.create(:user, case_id: case_id)
    end
  page.set_rack_session('cas_user' => @current_user.case_id)
  visit '/'
  # make sure we actually got signed in
  expect(page).to have_content(@current_user.case_id)
end

When(/^I visit "(.*)"$/) do |path|
  visit path
end

When(/^I click the link "(.*)"$/) do |text|
  click_link text
end

Then(/^I should see "(.*)"$/) do |content|
  expect(page).to have_content content
end

Then(/^I should not see "(.*)"$/) do |content|
  expect(page).to_not have_content content
end
