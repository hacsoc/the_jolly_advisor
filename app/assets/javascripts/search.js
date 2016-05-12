$(document).ready(function() {
  autocompleteCourseSearch();
  autocompleteWishlist();
  autocompleteCourseExplorer();
});

$(document).on('page:load', function() {
  autocompleteCourseSearch();
  autocompleteWishlist();
  autocompleteCourseExplorer();
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

function autocompleteCourseExplorer() {
    var explorerForm = '#explorer_main form ';
    $(explorerForm + '#search').autocomplete({
        source: '/courses/autocomplete.json',
        select: function(event, ui) {
            $(explorerForm + '#search').val(ui.item.val);
        }
    });

    $(explorerForm + '#professor').autocomplete({
        source: '/professors/autocomplete.json',
        select: function(event, ui) {
            $(explorerForm + '#professor').val(ui.item.label);
        }
    });
}
