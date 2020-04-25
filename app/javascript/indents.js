$(document).on('change', '#indent_company_id', function (e) {
  e.preventDefault();
  var companyId = $(this).find(":selected").val();

  if($.isNumeric(companyId) === false || companyId <= 0) { return }

  $.ajax({
    method: 'GET',
    url: '/transactions/indents/fetch_warehouses',
    data: { company_id: companyId }
  });
});

$(document).on('change', 'select.item-selector', function (e) {
  e.preventDefault();
  var itemId = $(this).find(":selected").val();
  var uniqueId = $(this).attr('id').split("_")[4];

  if($.isNumeric(itemId) === false || itemId <= 0) { return }

  $.ajax({
    method: 'GET',
    url: '/transactions/indents/fetch_makes_and_uoms',
    data: { item_id: itemId, unique_id: uniqueId }
  });
});
