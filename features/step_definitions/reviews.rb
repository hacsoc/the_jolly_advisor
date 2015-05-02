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
