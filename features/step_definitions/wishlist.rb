Given(/^I have the course ([A-Z]*) (\d+) in my wishlist$/) do |course_dept, course_number|
  course = Course.where(department: course_dept, course_number: course_number).first ||
    FactoryGirl.create(:course, department: course_dept, course_number: course_number)
  WishlistItem.exists?(course: course, user: @current_user) ||
    FactoryGirl.create(:wishlist_item, course: course, user: @current_user)
end
