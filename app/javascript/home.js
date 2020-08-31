// $(document).on('click', '#sidebar-toggler', function(e) {
//   $.ajax({
//     method: 'GET',
//     url: '/toggle_collapse',
//     dataType: 'json'
//   });
// });

$(document).on('click', '.sidenav-item-link', function(e) {
  $(this).parent().find('.sidenav-item-list').slideToggle();
});
