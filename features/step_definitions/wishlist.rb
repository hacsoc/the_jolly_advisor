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
