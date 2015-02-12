json.array!(@courses) do |course|
  json.extract! course, :id, :department, :course_number, :description, :course_offering
  json.url course_url(course, format: :json)
end
