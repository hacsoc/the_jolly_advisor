Given(/^I have the course ([A-Z]+) (\d+) in my wishlist$/) do |course_dept, course_number|
 course = Course.where(department: course_dept, course_number: course_number).first ||
           FactoryGirl.create(:course, department: course_dept, course_number: course_number)
  WishlistItem.exists?(course: course, user: @current_user) ||
    FactoryGirl.create(:wishlist_item, course: course, user: @current_user)
end

Given(/^I do not have the course ([A-Z]+) (\d+) in my wishlist$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first
  if course
    # if there's no course, there's definitely no wishlist item
    WishlistItem.destroy_all(course: course, user: @current_user)
  end
end

Given(/^My wishlist is empty$/) do
  WishlistItem.destroy_all(user: @current_user)
  expect(WishlistItem.where(user: @current_user).to_a).to eq []
end

Given(/^I do not have notifications turned on for ([A-Z]+) (\d+)$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first
  WishlistItem.where(course: course, user: @current_user).update_all(notify: false)
  expect(WishlistItem.where(course: course, user: @current_user, notify: true).to_a).to eq []
end

Given(/^I have notifications turned on for ([A-Z]+) (\d+)$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first
  WishlistItem.where(course: course, user: @current_user).update_all(notify: true)
  expect(WishlistItem.where(course: course, user: @current_user, notify: false).to_a).to eq []
end

Then(/^I should have the course ([A-Z]+) (\d+) in my wishlist$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first
  expect(course).to_not be nil
  expect(WishlistItem.exists?(course: course, user: @current_user)).to be true
end

Then(/^I should not have the course ([A-Z]+) (\d+) in my wishlist$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first
  # If the course doesn't exist it's definitely not in the wishlist
  expect(course && WishlistItem.exists?(course: course, user: @current_user)).to be false
end

Then(/^I should have notifications turned on for ([A-Z]+) (\d+)$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number)
  expect(WishlistItem.where(course: course, user: @current_user).first.notify).to be true
end

Then(/^I should have notifications turned off for ([A-Z]+) (\d+)$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number)
  expect(WishlistItem.where(course: course, user: @current_user).first.notify).to be false
end

Then(/^([A-Z]+) (\d+) is the first class in my wishlist$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number)
  row = page.all('tr')[1]
  course_data = row.all('td').first.text
  expected_dept = course_data[0...4]
  expected_number = course_data[4...course_data.length]
  expected_course = Course.where(department: expected_dept, course_number:
                                expected_number)
  expect(course == expected_course).to be true
end
