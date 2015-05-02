Given(/^The course ([A-Z]+) (\d+) has (\d+) reviews$/) do |dept, course_num, review_count|
  course = Course.where(department: dept, course_number: course_num.to_i).first ||
           FactoryGirl.create(:course, department: dept, course_number: course_num.to_i)
  count_diff = course.reviews.count - review_count.to_i
  if count_diff < 0
    FactoryGirl.create_list(:review, count_diff.abs, course: course)
  elsif count_diff > 0
    Review.where(course: course).limit(count_diff).destroy_all
  end
  expect(course.reload.reviews.count).to eq review_count.to_i
end

Given(/^The course ([A-Z]+) (\d+) has a review with helpfulness (\d+)$/) do |dept, course_num, helpfulness|
  course = Course.where(department: dept, course_number: course_num.to_i).first ||
           FactoryGirl.create(:course, department: dept, course_number: course_num.to_i)
  course.reviews.destroy_all
  @review = FactoryGirl.create(:review, course: course, helpfulness: helpfulness.to_i)
  course.reload
  expect(course.reviews.count).to eq 1
  expect(course.reviews.first.helpfulness).to eq helpfulness.to_i
end

When(/^I click the (.*) button for that review$/) do |button_class|
  within('#reviews') do
    find(".#{button_class}").click
  end
end

Then(/^That review should have helpfulness (\d+)$/) do |helpfulness|
  expect(@review.reload.helpfulness).to eq helpfulness.to_i
  within('#reviews') do
    expect(find('span.helpfulness').text).to eq helpfulness
  end
end

Then(/^I should see (\d+) reviews$/) do |count|
  reviews = page.all('#reviews .review')
  expect(reviews.count).to eq count.to_i
end

Then(/^The reviews should be ordered by helpfulness$/) do
  reviews = page.all('#reviews .review')
  reviews.each_with_index do |review_row, index|
    if reviews[index + 1]
      expect(review_row.find('span.helpfulness').text.to_i).to be >=
        reviews[index + 1].find('span.helpfulness').text.to_i
    end
  end
end
