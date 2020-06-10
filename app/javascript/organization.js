$(document).on('change', '.fy-start-month-selection', function(){
  startMonth = parseInt($(this).val());

  if (startMonth === 1) {
    endMonth = 12;
  } else {
    endMonth = startMonth - 1;
  }

  $('.fy-end-month-selection').val(endMonth);
});

$(document).on('change', '.fy-end-month-selection', function () {
  endMonth = parseInt($(this).val());

  if (endMonth === 12) {
    startMonth = 1;
  } else {
    startMonth = endMonth + 1;
  }

  $('.fy-start-month-selection').val(startMonth);
});
