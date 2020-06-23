$(document).on('click', '#sidebar-toggler', function(e) {
  $.ajax({
    method: 'GET',
    url: '/toggle_collapse',
    dataType: 'json'
  });
});

var loadNextPage = function () {
  if ($('#records_table').height() === undefined || $('#next_link').data("loading")) { return }  // prevent multiple loading
  var wBottom = $(window).scrollTop() + $(window).height();
  var elBottom = $('#records_table').offset().top + $('#records_table').height();

  if (wBottom > elBottom) {
    if ($('#next_link')[0] !== undefined) {    // checking next page link is available or not
      $('.se-pre-con').show();
      $('#next_link')[0].click();
      $('#next_link').data("loading", true);
    }
  }
};

window.addEventListener('resize', loadNextPage);
window.addEventListener('scroll', loadNextPage);
window.addEventListener('load', loadNextPage);
