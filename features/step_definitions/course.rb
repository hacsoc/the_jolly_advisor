Given(/^The course ([A-Z]+) (\d+) exists$/) do |department, course_number|
  Course.exists?(department: department, course_number: course_number) ||
    FactoryGirl.create(:course, :with_course_instance, department: department, course_number: course_number)
end
