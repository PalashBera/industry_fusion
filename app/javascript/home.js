$(document).on('click', '.app-sidebar', function(e) {
  $.ajax({
    method: 'GET',
    url: '/collapse',
    dataType: 'json'
  });
});
