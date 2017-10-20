json.array!(@scheduled_meetings) do |scheduled_meeting|
  # ensures that all ScheduledMeetings for the same meeting have the same id
  json.id    scheduled_meeting.meeting.id
  json.title scheduled_meeting.meeting.course_instance.course.to_param
  json.start scheduled_meeting.start_time.to_time.iso8601
  json.end   scheduled_meeting.end_time.to_time.iso8601
  json.url   scheduler_path(course_instance_id: scheduled_meeting.meeting.course_instance.id)

  # Additional attributes that fullcalendar doesn't recognize
  # Used in the eventRender callback
  json.description scheduled_meeting.meeting.course_instance.course.title
end
