// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('indents')
require('plugins/theme')
require('plugins/simplebar.min')
require('indents')

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

  $('.se-pre-con').fadeOut('slow');
});

$(document).on('click', '.remove_fields', function (event) {
  event.preventDefault();
  $(this).prev('input[type=hidden]').val('1');
  $(this).closest('section').find(':input').removeAttr('required');
  $(this).closest('section').hide();
});

$(document).on('click', '.add_fields', function (event) {
  event.preventDefault();
  var regexp, time;
  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  $(this).before($(this).data('fields').replace(regexp, time));
});
