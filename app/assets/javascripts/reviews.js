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
  $('a.upvote').on('ajax:success', function(data) { updateHelpfulness(this, 1, 'a.downvote'); });
}

function addDownvoteHandler() {
  $('a.downvote').on('ajax:success', function (data) { updateHelpfulness(this, -1, 'a.upvote'); });
}

function updateHelpfulness(link, amount, otherLinkSelector) {
  var div = $(link).closest('div');
  var helpfulness = div.find('.helpfulness');
  var otherLink = div.find(otherLinkSelector);
  if (otherLink.hasClass('disabled')) {
    amount *= 2;
    otherLink.removeClass('disabled');
  }
  helpfulness.text(parseInt(helpfulness.text()) + amount);
  $(link).addClass('disabled');
}
