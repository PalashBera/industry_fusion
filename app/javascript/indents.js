$(document).on('change', '#indent_company_id', function (e) {
  var companyId = $(this).find(':selected').val();

  $.ajax({
    method: 'GET',
    url: `/transactions/companies/${companyId}/warehouses`,
    dataType: 'json',
    success: function(data, status, xhr) {
      options = '<option value>-- Select Warehouse --</option>';

      $.each(data['warehouses'], function(index, warehouse) {
        options += `<option value='${warehouse.id}'>${warehouse.name}</option>`;
      });

      $('#indent_warehouse_id').html(options);
    }
  });
});

$(document).on('change', '.indent-item-selection', function (e) {
  e.preventDefault();
  var itemId = $(this).find(':selected').val();
  var uniqueId = $(this).attr('id').split('_')[4];

  $.ajax({
    method: 'GET',
    url: `/transactions/items/${itemId}/makes`,
    dataType: 'json',
    success: function(data, status, xhr) {
      options = '<option value>-- Make --</option>';

      $.each(data['makes'], function(index, make) {
        options += `<option value='${make.id}'>${make.brand_with_cat_no}</option>`;
      });

      $(`#indent_indent_items_attributes_${uniqueId}_make_id`).html(options);
    }
  });

  $.ajax({
    method: 'GET',
    url: `/transactions/items/${itemId}/uoms`,
    dataType: 'json',
    success: function(data, status, xhr) {
      options = '<option value>-- UOM --</option>';

      $.each(data['uoms'], function(index, uom) {
        options += `<option value='${uom.id}'>${uom.short_name}</option>`;
      });

      $(`#indent_indent_items_attributes_${uniqueId}_uom_id`).html(options);
    }
  });
});

$( document ).on('turbolinks:load', function() {
  if($('select').hasClass('disabled')) {
    console.log("hi");
    $('.disabled').attr("disabled", true)
  }
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
