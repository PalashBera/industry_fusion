$(document).on('click', '#sidebar-toggler', function(e) {
  $.ajax({
    method: 'GET',
    url: '/toggle_collapse',
    dataType: 'json'
  });
});
