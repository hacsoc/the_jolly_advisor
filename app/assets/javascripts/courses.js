// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $("#course-autocomplete").autocomplete({
    source: "/courses/autocomplete.json",
    select: function(event, ui) {
      window.location.href = "/courses/" + ui.item.value;
    }
  });
});
