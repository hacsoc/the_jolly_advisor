And(/^I have (\d+) courses to search$/) do |num_classes|
  num_classes.to_i.times do
    FactoryGirl.create(:course, :with_course_instance)
  end
end

Given(/^The course ([A-Z]+) (\d+) exists$/) do |department, course_number|
  Course.exists?(department: department, course_number: course_number) ||
    FactoryGirl.create(
      :course,
      :with_course_instance,
      department: department,
      course_number: course_number,
    )
end

When(/^I search for a professor$/) do
  # Grab the first professor or course
  @professor = Professor.first
  fill_in 'professor', with: @professor.name
  click_button 'Search'
end

Then(/^I only see courses taught by that professor$/) do
  # Collect all classes returned
  page.all('#results tr').each do |row|
    course_data = row.all('td').first.text
    dept, num = course_data.split ' '
    professors = Course.includes(course_instances: :professor)
                       .find_by(department: dept, course_number: num)
                       .professors
    names = professors.map(&:name)
    expect(names).to include(start_with(@professor.name))
  end
end

When(/^I search for a course by course department and number$/) do
  @course = Course.all.sample # O(n) but test data small so yolo.
  # Need to find by id, since there are 2 elements on the page with the name
  # "search" so that the navbar searching does not require autocomplete
  find('#search').set("#{@course.department}#{@course.course_number}")
  click_button 'Search'
end

Then(/^I only see that course in the list$/) do
  page.all('#results tr').each do |row|
    expect("#{@course.department} #{@course.course_number}").to eq row.all('td').first.text
  end
end

When(/^I search for a department$/) do
  @dept = Course.all.sample.department # O(n) but test data small so yolo.
  find('#search').set(@dept)
  click_button 'Search'
end

Then(/^I only see classes from that department$/) do
  page.all('#results tr').each do |row|
    expect(@dept).to eq row.all('td').first.text[0...4]
  end
end

When(/^I search for courses by a keyword$/) do
  courses_with_titles = Course.where.not(title: nil)
  @keyword = courses_with_titles.sample.title.split(' ').sample
  find('#search').set(@keyword)
  click_button 'Search'
end

Then(/^I see only classes with that keyword in the name$/) do
  page.all('#results tr').each do |row|
    expect(row.all('td').last.text.downcase).to include @keyword.downcase
  end
end

Given(/^An unfiltered list of courses$/) do
  find('#search').set('')
  fill_in 'professor', with: ''
  select 'All', from: 'semester'
  click_button 'Search'
  @all_courses = page.all('#results tr')
end

Then(/^I can page through courses$/) do
  # Next Page
  page.find(:css, '.next').click
  # New data should not be different from our data
  expect(@all_courses.to_a - page.all('#results tr').to_a).not_to be_empty
end

When(/^I select a class on the Course Explorer Page$/) do
  @course = page.all('#results tr').to_a.sample
  @course_num = @course.all('td').first.text
  @course_title = @course.all('td').last.text
  within(@course.all('td').first) do
    click_on @course_num
  end
end

Then(/^I am taken to the show page of that class$/) do
  expect(current_path).to eq "/courses/#{@course_num.delete(' ')}"
  # Expect h2 to eq course department coursenum
  expect(page.find('h2').text).to eq "#{@course_num}: #{@course_title}"
end

And(/^the courses are in ascending order$/) do
  page.all('#results tr').each_with_index do |row, i|
    unless page.all('#results tr')[i - 1]
      current = row.all('td').first.text
      previous = page.all('#results tr')[i - 1].all('td').first.first.text
      expect(current).to be >= previous
    end
  end
end
