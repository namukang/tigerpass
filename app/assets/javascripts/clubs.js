$('.club').hover(function() {
  // mouse hovers over club
  $('.club').addClass('faded');
  $(this).removeClass('faded');
}, function() {});

$('#clubLogos').hover(function(){}, function() {
  // mouse hovers off club list
  $('.club').removeClass('faded');
});
