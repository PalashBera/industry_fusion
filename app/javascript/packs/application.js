// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

document.addEventListener('turbolinks:load', function() {
  $('.flash-alert').delay(4000).slideUp(200, function() {
    $(this).alert('close');
  });

  $(".selectpicker").selectpicker({
    size: '7'
  });

  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
    $('.selectpicker').selectpicker('mobile');
  }

  $('.selectpicker').selectpicker('refresh');
  $('.se-pre-con').fadeOut('slow');
});

$(document).on('click', '.remove-selectpicker-selections', function (e) {
  e.preventDefault();
  $(this).parent().find('.selectpicker').selectpicker('val', '');
});

$(document).on('click', 'a', function (e) {
  element = $(this)

  if (element.hasClass('no-preloader') || element.attr('role') === "option"){
    return;
  }

  $('.se-pre-con').show();
});
