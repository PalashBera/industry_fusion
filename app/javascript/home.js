$(document).on('click', '.app-sidebar', function(e) {
  $.ajax({
    method: 'GET',
    url: '/toggle_collapse',
    dataType: 'json'
  });
});
