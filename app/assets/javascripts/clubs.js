// Only show events for day
function filter_events(day) {
  $('.event').hide();
  $('.event').filter('.' + day).show();
}

$(function() {
  $('.club').hover(function() {
    // mouse hovers over club
    $('.club').addClass('faded');
    $(this).removeClass('faded');
  }, null);

  $('#clubLogos').hover(null, function() {
    // mouse hovers off club list
    $('.club').removeClass('faded');
  });

  $('#buttons a').click(function(e) {
    e.preventDefault();
    $('.currentDayButton').addClass('dayButton');
    $('.currentDayButton').removeClass('currentDayButton');
    $(this).children('.button').removeClass('dayButton');
    $(this).children('.button').addClass('currentDayButton');
    // filter_events($(this).attr('id'));
  });
});
