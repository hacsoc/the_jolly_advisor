module SchedulerHelper
  def scheduler_feed
    scheduler_path(semester: params[:semester] || nil)
  end

  def course_instance_autocomplete(jump_date = Date.today)
    # jump_date could be a DateTime, so just make sure it's actually a Date
    autocomplete_course_instances_path(current_date: jump_date.to_date)
  end
end
