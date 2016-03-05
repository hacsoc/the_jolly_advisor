When(/^I am viewing a course$/) do
  @course = Course.first || FactoryGirl.create(:course)
  step "I visit \"/courses/#{@course.to_param}\""
end
