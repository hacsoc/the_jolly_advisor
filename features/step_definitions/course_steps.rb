When(/^I am viewing (a|that) course$/) do |selection|
  @course =
    case selection
    when 'a'
      Course.first || FactoryBot.create(:course)
    when 'that'
      @course
    end
  expect(@course).to_not be nil
  visit "/courses/#{@course.to_param}"
end
