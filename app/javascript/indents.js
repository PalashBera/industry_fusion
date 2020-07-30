$(document).on('click', '.bulk-action-checkbox', function (e) {
  var checkedCount = $('.bulk-action-checkbox:checked').length;
  var totalCount = $('.bulk-action-checkbox').length;

  if (checkedCount > 0) {
    $('.bulk-action-dropdown').removeClass('hide')
  } else {
    $('.bulk-action-dropdown').addClass('hide')
  }

  if (totalCount === checkedCount) {
    $('.bulk-action-select-all-checkbox').prop('checked', true);
  } else {
    $('.bulk-action-select-all-checkbox').prop('checked', false);
  }
});

$(document).on('click', '.bulk-action-select-all-checkbox', function (e) {
  if ($(this).is(":checked") === true) {
    $('.bulk-action-checkbox').prop('checked', true)
    $('.bulk-action-dropdown').removeClass('hide')
  } else {
    $('.bulk-action-checkbox').prop('checked', false)
    $('.bulk-action-dropdown').addClass('hide')
  }
});

$(document).on('change', '#indent_company_id', function (e) {
  var companyId = $(this).find(':selected').val();

  $.ajax({
    method: 'GET',
    url: `/procurement/companies/${companyId}/warehouses`,
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
    url: `/procurement/items/${itemId}/makes`,
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
    url: `/procurement/items/${itemId}/uoms`,
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
