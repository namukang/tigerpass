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
});
