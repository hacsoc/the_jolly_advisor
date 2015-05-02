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
