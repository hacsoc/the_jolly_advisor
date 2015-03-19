json.array!(@scheduled_meetings) do |scheduled_meeting|
  json.title scheduled_meeting.meeting.course_instance.course.to_param
  json.start scheduled_meeting.start_time.to_time.iso8601
  json.end   scheduled_meeting.end_time.to_time.iso8601
end
