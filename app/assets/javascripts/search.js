$(document).ready(function(){
  $("#course-autocomplete").autocomplete({
    source: "/courses/autocomplete.json",
    select: function(event, ui) {
      window.location.href = "/courses/" + ui.item.value;
    }
  });
});

$(document).ready(function() {
  autocomplete_wishlist();
});

$(document).on('page:load', function() {
  autocomplete_wishlist();
});

function autocomplete_wishlist() {
  $('#wishlist_course_form #course_title').autocomplete({
    source: '/courses/autocomplete.json',
    select: function(event, ui) {
      $('#wishlist_course_form #course_id').val(ui.item.id);
      $('#wishlist_course_form').submit();
    }
  });
}

