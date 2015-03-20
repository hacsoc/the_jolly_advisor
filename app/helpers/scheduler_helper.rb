module SchedulerHelper
  def scheduler_feed
    scheduler_path(semester: params[:semester] || nil)
  end
end
