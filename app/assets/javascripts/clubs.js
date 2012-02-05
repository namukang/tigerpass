var selected_club = null;

// Filter events shown
function filter_events(filter) {
  $('.event').hide();
  var events = $('.event').filter('.' + filter);
  if (events.length === 0) {
    $('.campus').show();
    if (selected_club === null) {
      $('.date_msg').show();
      $('.club_msg').hide();
    } else {
      $('.date_msg').hide();
      $('.club_msg').show();
    }
  } else {
    events.show();
  }
}

$(function() {
  if (window.location.pathname === "/") {
    // Filter results by default
    var current_day = $('.currentDayButton').parent().attr('id');
    filter_events(current_day);
  }

  $('.club').hover(function() {
    if (selected_club === null) {
      // mouse hovers over club
      $('.club').addClass('faded');
      $(this).removeClass('faded');
    }
  }, null);

  $('#clubLogos').hover(null, function() {
    if (selected_club === null) {
      // mouse hovers off club list
      $('.club').removeClass('faded');
    }
  });

  $('#buttons a').click(function(e) {
    e.preventDefault();
    // Make all club logos faded
    selected_club = null;
    $('.club').removeClass('faded');
    // Unpress all buttons
    $('.currentDayButton').addClass('dayButton');
    $('.currentDayButton').removeClass('currentDayButton');
    // Press this button
    $(this).children('.button').removeClass('dayButton');
    $(this).children('.button').addClass('currentDayButton');
    // Only show events for this day
    filter_events($(this).attr('id'));
  });

  $('#clubLogos a').click(function(e) {
    e.preventDefault();
    var selected_logo = $(this).children('div').first();
    // FIXME: I'm not proud of this
    var club = selected_logo.attr('class').split(" ")[0];
    // Deselect club if clicked twice
    if (club === selected_club) {
      $('.todayButton').parent().click();
      return;
    } else {
      selected_club = club;
    }
    // Fade all clubs except this one
    $('.club').addClass('faded');
    selected_logo.removeClass('faded');
    // Unpress all buttons
    $('.button').addClass('dayButton');
    $('.button').removeClass('currentDayButton');
    // Only show this club's events
    filter_events(club + "_event")
  });
});
