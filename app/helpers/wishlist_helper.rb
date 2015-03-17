module WishlistHelper
  def add_remove_link(wishlist_course_ids, course)
    link_to "#{wishlist_course_ids.include?(course.id) ? 'Remove from' : 'Add to'} my wishlist",
            wishlist_path(course_id: course.id, url: request.original_url),
            method: wishlist_course_ids.include?(course.id) ? :delete : :post
  end

  def set_notify_link(item)
    link_to "Turn #{item.notify ? 'off' : 'on'} notifications",
            wishlist_path(course_id: item.course_id, wishlist_item: { notify: !item.notify }),
            method: :put
  end
end
