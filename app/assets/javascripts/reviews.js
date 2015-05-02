// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  addUpvoteHandler();
  addDownvoteHandler();
});

$(document).on('page:load', function() {
  addUpvoteHandler();
  addDownvoteHandler();
});

function addUpvoteHandler() {
  $('a.upvote').on('ajax:success', function(data) { updateHelpfulness(this, 1); });
}

function addDownvoteHandler() {
  $('a.downvote').on('ajax:success', function (data) { updateHelpfulness(this, -1); });
}

function updateHelpfulness(link, amount) {
  var helpfulness = $(link).closest('div').find('.helpfulness');
  helpfulness.text(parseInt(helpfulness.text()) + amount);
}
