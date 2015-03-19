json.array!(@course_instances) do |course_instance|
  json.title course_instance.course.to_param
  json.start DateTime.now.strftime('%Y-%m-%dT%H:%M:%S%:z')
  json.end 1.hour.from_now.strftime('%Y-%m-%dT%H:%M:%S%:z')
end
