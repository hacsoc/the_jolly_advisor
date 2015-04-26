$(document).ready(function() {
  autocompleteCourseSearch();
  autocompleteWishlist();
});

$(document).on('page:load', function() {
  autocompleteCourseSearch();
  autocompleteWishlist();
});

function autocompleteCourseSearch() {
  $('#course-autocomplete').autocomplete({
    source: '/courses/autocomplete.json',
    select: function(event, ui) {
      window.location.href = '/courses/' + ui.item.value;
    }
  });
}

function autocompleteWishlist() {
  $('#wishlist_course_form #course_title').autocomplete({
    source: '/courses/autocomplete.json',
    select: function(event, ui) {
      $('#wishlist_course_form #course_id').val(ui.item.id);
      $('#wishlist_course_form').submit();
    }
  });
}

