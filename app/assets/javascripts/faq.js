
// Show/hide answers to questions
jQuery(function ($) {
    $('.panel-heading span.clickable').on('click', function () {
        if ($(this).hasClass('panel-collapsed')) {
            // expand the panel
            $(this).parents('.panel').find('.answer-body').slideDown();
            $(this).removeClass('panel-collapsed');
            $(this).find('i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
        }
        else {
            // collapse the panel
            $(this).parents('.panel').find('.answer-body').slideUp();
            $(this).addClass('panel-collapsed');
            $(this).find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
        }
    });
});