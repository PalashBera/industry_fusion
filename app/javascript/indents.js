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
      SelectpickerHandler();
    }
  });
});

$(document).on('change', 'select.item-selector', function (e) {
  e.preventDefault();
  var itemId = $(this).find(':selected').val();
  var uniqueId = $(this).attr('id').split('_')[4];

  $.ajax({
    method: 'GET',
    url: `/transactions/items/${itemId}/makes`,
    dataType: 'json',
    success: function(data, status, xhr) {
      options = '<option value>-- Select Make --</option>';

      $.each(data['makes'], function(index, make) {
        options += `<option value='${make.id}'>${make.brand_name}</option>`;
      });

      $(`#indent_indent_items_attributes_${uniqueId}_make_id`).html(options);
      SelectpickerHandler();
    }
  });

  $.ajax({
    method: 'GET',
    url: `/transactions/items/${itemId}/uoms`,
    dataType: 'json',
    success: function(data, status, xhr) {
      options = '<option value>-- Select UOM --</option>';

      $.each(data['uoms'], function(index, uom) {
        options += `<option value='${uom.id}'>${uom.short_name}</option>`;
      });

      $(`#indent_indent_items_attributes_${uniqueId}_uom_id`).html(options);
      SelectpickerHandler();
    }
  });
});

const SelectpickerHandler = function () {
  $(".selectpicker").selectpicker({ size: '7' });

  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
    $('.selectpicker').selectpicker('mobile');
  }

  $('.selectpicker').selectpicker('refresh');
}
