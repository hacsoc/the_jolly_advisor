$(document).ready(function(){
  $("#course-autocomplete").autocomplete({
    source: "/courses/autocomplete.json",
    select: function(event, ui) {
      window.location.href = "/courses/" + ui.item.value;
    }
  });
});
