$(document).on('turbolinks:load', function() {
  $('.alert .close').click(function() {
    $(this).parent().slideUp();
  })
});
