$(document).ready(function(){
  $("#course-autocomplete").autocomplete({
    source: "/courses/autocomplete.json",
    select: function(event, ui) {
      window.location.href = "/courses/" + ui.item.value;
    }
  });

  $('#wishlist_course_form #course_title').autocomplete({
    source: '/courses/autocomplete.json',
    select: function(event, ui) {
      $('#wishlist_course_form #course_id').val(ui.item.id);
      $('#wishlist_course_form').submit();
    }
  });
});
