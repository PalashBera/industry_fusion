$(document).on('ready turbolinks:load', function() {
  "use strict";

  /*======== MOBILE OVERLAY ========*/
  if ($(window).width() < 768) {
    $(".sidebar-toggle").on("click", function() {
      $("body").css("overflow", "hidden");
      $('body').prepend('<div class="mobile-sticky-body-overlay"></div>')
    });

    $(document).on("click", '.mobile-sticky-body-overlay', function(e) {
      $(this).remove();
      $("#body").removeClass("sidebar-mobile-in").addClass("sidebar-mobile-out");
      $("body").css("overflow", "auto");
    });
  }

  /*======== SIDEBAR TOGGLE FOR MOBILE ========*/
  if ($(window).width() < 768) {
    $(".sidebar-toggle").click(function(e) {
      e.preventDefault();
      var min = "sidebar-mobile-in",
        min_out = "sidebar-mobile-out",
        body = "#body";
      $(body).hasClass(min)
        ? $(body)
            .removeClass(min)
            .addClass(min_out)
        : $(body)
            .addClass(min)
            .removeClass(min_out)
    });
  }

  /*======== SIDEBAR TOGGLE FOR VARIOUS SIDEBAR LAYOUT ========*/
  var body = $("#body");
  if ($(window).width() >= 768) {

    if (body.hasClass('sidebar-mobile-in sidebar-mobile-out')){
      body.removeClass('sidebar-mobile-in sidebar-mobile-out');
    }

    window.isMinified = false;
    window.isCollapsed = false;

    $("#sidebar-toggler").on("click", function () {
      if (
        body.hasClass("sidebar-fixed-offcanvas") ||
        body.hasClass("sidebar-static-offcanvas")
      ) {
        $(this)
          .addClass("sidebar-offcanvas-toggle")
          .removeClass("sidebar-toggle");
        if (window.isCollapsed === false) {
          body.addClass("sidebar-collapse");
          window.isCollapsed = true;
          window.isMinified = false;
        } else {
          body.removeClass("sidebar-collapse");
          body.addClass("sidebar-collapse-out");
          setTimeout(function () {
            body.removeClass("sidebar-collapse-out");
          }, 300);
          window.isCollapsed = false;
        }
      }

      if (
        body.hasClass("sidebar-fixed") ||
        body.hasClass("sidebar-static")
      ) {
        $(this)
          .addClass("sidebar-toggle")
          .removeClass("sidebar-offcanvas-toggle");
        if (window.isMinified === false) {
          body
            .removeClass("sidebar-collapse sidebar-minified-out")
            .addClass("sidebar-minified");
          window.isMinified = true;
          window.isCollapsed = false;
        } else {
          body.removeClass("sidebar-minified");
          body.addClass("sidebar-minified-out");
          window.isMinified = false;
        }
      }
    });
  }

  if ($(window).width() >= 768 && $(window).width() < 992) {
    if (
      body.hasClass("sidebar-fixed") ||
      body.hasClass("sidebar-static")
    ) {
      body
        .removeClass("sidebar-collapse sidebar-minified-out")
        .addClass("sidebar-minified");
      window.isMinified = true;
    }
  }

  /*======== TODO LIST ========*/

  function todoCheckAll() {
    var mdis = document.querySelectorAll(".todo-single-item .mdi");
    mdis.forEach(function(fa) {
      fa.addEventListener("click", function(e) {
        e.stopPropagation();
        e.target.parentElement.classList.toggle("finished");
      });
    });
  }

  if (document.querySelector("#todo")) {
    var list = document.querySelector("#todo-list"),
      todoInput = document.querySelector("#todo-input"),
      todoInputForm = todoInput.querySelector("form"),
      item = todoInputForm.querySelector("input");

    document.querySelector("#add-task").addEventListener("click", function(e) {
      e.preventDefault();
      todoInput.classList.toggle("d-block");
      item.focus();
    });

    todoInputForm.addEventListener("submit", function(e) {
      e.preventDefault();
      if (item.value.length <= 0) {
        return;
      }
      list.innerHTML =
        '<div class="todo-single-item d-flex flex-row justify-content-between">' +
        '<i class="mdi"></i>' +
        '<span>' +
        item.value +
        '</span>' +
        '<span class="badge badge-primary">Today</span>' +
        '</div>' +
        list.innerHTML;
      item.value = "";
      //Close input field
      todoInput.classList.toggle("d-block");
      todoCheckAll();
    });

    todoCheckAll();
  }

  /*======== RIGHT SIDEBAR ========*/
  if ($(window).width() < 1025) {
    body.addClass('right-sidebar-toggoler-out');

    var btnRightSidebarToggler = $('.btn-right-sidebar-toggler');

    btnRightSidebarToggler.on('click', function () {

      if (!body.hasClass('right-sidebar-toggoler-out')) {
        body.addClass('right-sidebar-toggoler-out').removeClass('right-sidebar-toggoler-in');
      } else {
        body.addClass('right-sidebar-toggoler-in').removeClass('right-sidebar-toggoler-out')
      }

    });

  }

  var navRightSidebarLink = $('.nav-right-sidebar .nav-link');

  navRightSidebarLink.on('click', function () {

    if(!body.hasClass('right-sidebar-in')){
      body.addClass('right-sidebar-in').removeClass('right-sidebar-out');

    } else if ($(this).hasClass('show')){
      body.addClass('right-sidebar-out').removeClass('right-sidebar-in');
    }
  });


  var cardClosebutton = $('.card-right-sidebar .close');
  cardClosebutton.on('click', function () {
    body.removeClass('right-sidebar-in').addClass('right-sidebar-out');
  })

  /*======== OFFCANVAS ========*/
  var offcanvasToggler = $('.offcanvas-toggler');
  var cardOffcanvas = $('.card-offcanvas');

  offcanvasToggler.on('click', function () {
    var offcanvasId = $(this).attr('data-offcanvas');
    cardOffcanvas.removeClass('active');
    $("#"+offcanvasId).addClass('active');
    $('#body').append('<div class="offcanvas-overlay"></div>');
  });

  /* Overlay Click*/
  $(document).on('click', '.offcanvas-overlay', function(){
    $(this).remove();
    cardOffcanvas.removeClass('active');
  });

  /*======== DROPDOWN NOTIFY ========*/
  var dropdownToggle = $('.notify-toggler');
  var dropdownNotify = $('.dropdown-notify');

  if (dropdownToggle.length !== 0){
    dropdownToggle.on('click', function () {
      if (!dropdownNotify.is(':visible')){
        dropdownNotify.fadeIn(5);
      }else {
        dropdownNotify.fadeOut(5);
      }
    });

    $(document).mouseup(function (e) {
      if (!dropdownNotify.is(e.target) && dropdownNotify.has(e.target).length === 0){
        dropdownNotify.fadeOut(5);
      }
    });


  }

  /*======== REFRESS BUTTON ========*/
  var refressButton = $('#refress-button');
  if (refressButton !== 0){
    refressButton.on('click', function () {
      $(this).addClass('mdi-spin');
      var $this = $(this);
      setTimeout(function () {
        $this.removeClass('mdi-spin');
      }, 3000);
    });
  }

  /*======== NAVBAR TRANSPARENT SCROLL ========*/
  var body = $('#body');
  var navbar = $('#navbar');
  $(window).scroll(function () {

    if (body.hasClass('navbar-fixed') && $(this).width() > 765 && navbar.hasClass('navbar-transparent') ) {
      var scroll = $(window).scrollTop();

      if (scroll >= 10) {
        navbar.addClass("navbar-light").addClass("navbar-transparent");
      } else {
        navbar.removeClass("navbar-light").addClass("navbar-transparent");
      }
    }

  });

  /*======== NAVBAR SEARCH ========*/
  var searchInput = $("#search-input");
  if (searchInput !== 0){
    var inputSearch = $('#input-group-search');
    searchInput.focus(function () {
      $(".dropdown-menu-search").show();
      removeRadius();
      $(this).addClass('focus');

    });

    searchInput.focusout(function () {
      $(".dropdown-menu-search").hide();
      addRadius();
      $(this).removeClass('focus');
    });

    function removeRadius(){
      inputSearch.css({
        'border-bottom-left-radius': '0',
        'border-bottom-right-radius': '0'
      });
    }

    function addRadius(){
      inputSearch.css({
        'border-bottom-left-radius': '.5rem',
        'border-bottom-right-radius': '.5rem'
      });
    }

    window.displayBoxIndex = -1;
    searchInput.keyup(function (e) {
      if (e.keyCode == 40) {
        Navigate(1);
      }
      if (e.keyCode == 38) {
        Navigate(-1);
      }
      if (e.keyCode == 27){
        $(".dropdown-menu-search").hide();
        addRadius();
      }

    });

    var Navigate = function (diff) {
      displayBoxIndex += diff;
      var oBoxCollection = $(".dropdown-menu-search .nav-item");
      if (displayBoxIndex >= oBoxCollection.length)
        displayBoxIndex = 0;
      if (displayBoxIndex < 0)
        displayBoxIndex = oBoxCollection.length - 1;
      var cssClass = "active";
      oBoxCollection.removeClass(cssClass).eq(displayBoxIndex).addClass(cssClass);
    }
  }

  /*======== TOOLTIPS AND POPOVER ========*/
  $('[data-toggle="tooltip"]').tooltip({
    container: "body",
    template:
      '<div class="tooltip" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
  });
  $('[data-toggle="popover"]').popover();

  /*======== JVECTORMAP HOME WORLD ========*/
  var homeWorld = $('#home-world');
  if (homeWorld.length != 0){
    var colorData = {
      CA: 106,
      US: 166,
      RU: 166,
      AR: 166,
      AU: 120,
      IN: 106
    };
    homeWorld.vectorMap({
      map: 'world_mill',
      backgroundColor: "#fff",
      zoomOnScroll: false,
      regionStyle: {
        initial: {
          fill: '#cbccd4'
        },
      },
     series: {
        regions: [
          {
            values: colorData,
            scale: ['#9e6cdf', '#dfe0e4', '#f9aec9'],
          }
        ]
      }
    });
  }

  /*======== JVECTORMAP USA REGIONS VECTOR MAP ========*/
  var usVectorMap = $('#us-vector-map-marker');
  if (usVectorMap.length != 0){
    usVectorMap.vectorMap({
      map: 'us_aea',
      backgroundColor: "#transparent",
      zoomOnScroll: false,
      regionStyle: {
        initial: {
          fill: '#eff0f5'
        },
      },
      markerStyle: {
        hover: {
          stroke: 'transparent'
        },
      },
      markers: [
        {
          latLng: [39.55, -105.78], name: 'Colorado', style: { fill: "#46c79e", stroke: '#46c79e' }
        },
        { latLng: [40.26, -86.13], name: 'Indiana', style: { fill: "#fec402", stroke: '#fec402' } },
        { latLng: [43.80, -120.55], name: 'Oregon', style: { fill: "#9e6de0", stroke: '#9e6de0' } }
      ]
    });
  }

  /*======== COUNTRY SALES RANGS ========*/
  var countrySalesRange = $('#country-sales-range');
  if (countrySalesRange.length != 0) {
    var start = moment().subtract(29, 'days');
    var end = moment();

    function cb(start, end) {
      $('#country-sales-range .date-holder').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }

    countrySalesRange.daterangepicker({
      startDate: start,
      endDate: end,
      opens: 'left',
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }, cb);

    cb(start, end);
  }
  var miniStatusRanges = $('#mini-status-range');

  if (miniStatusRanges.length != 0) {
    var start = moment().subtract(29, 'days');
    var end = moment();

    function cb(start, end) {
      $('#mini-status-range .date-holder').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }

    miniStatusRanges.daterangepicker({
      startDate: start,
      endDate: end,
      opens: 'left',
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }, cb);

    cb(start, end);
  }

  /*======== JVECTORMAP HOME WORLD ========*/
  var countryWithMarker = $('#world-country-with-marker');
  if (countryWithMarker.length != 0) {
    var colorData = {
      CA: 106,
      US: 166,
      RU: 166,
      AR: 166,
      AU: 120,
      IN: 106
    };
    countryWithMarker.vectorMap({
      map: 'world_mill',
      backgroundColor: "#fff",
      zoomOnScroll: false,
      regionStyle: {
        initial: {
          fill: '#cbccd4'
        },
      },
      series: {
        regions: [
          {
            values: colorData,
            scale: ['#9e6cdf', '#dfe0e4', '#f9aec9'],
          }
        ]
      },
      markers: [
        { latLng: [56.13, -106.34], name: 'Vatican City' },
        { latLng: [37.09, -95.71], name: 'Washington' },
        { latLng: [-14.23, -51.92], name: 'Brazil' },
        { latLng: [17.6078, 8.0817], name: 'Tuvalu' },
        { latLng: [47.14, 9.52], name: 'Liechtenstein' },
        { latLng: [20.59, 78.96], name: 'India' },
        { latLng: [61.52, 105.31], name: 'Russia' },
      ]
    });
  }

  var usVectorMapWithoutMarker = $('#us-vector-map-without-marker');
  if (usVectorMapWithoutMarker.length != 0) {
    usVectorMapWithoutMarker.vectorMap({
      map: 'us_aea',
      backgroundColor: "#transparent",
      zoomOnScroll: false,
      regionStyle: {
        initial: {
          fill: '#eff0f5'
        },
      },
      markerStyle: {
        hover: {
          stroke: 'transparent'
        },
      },

    });
  }

  /*======== CODE EDITOR ========*/
  var codeEditor = document.getElementById("code-editor");
  if (codeEditor) {
    var htmlCode =

    `<html style="color: green">
      <!-- this is a comment -->
      <head>"
        <title>HTML Example</title>
      </head>
      <body>
        The indentation tries to be <em>somewhat &quot;do what
        I mean&quot;</em>... but might not match your style.
      </body>
    </html>`

    var myCodeMirror = CodeMirror(codeEditor, {
      value: htmlCode,
      mode: "xml",
      extraKeys: { "Ctrl-Space": "autocomplete" },
      lineNumbers: true,
      indentWithTabs: true,
      lineWrapping: true
    });
  }



  /*======== QUILL TEXT EDITOR ========*/
  var quillHook = document.getElementById("editor");
  if (quillHook !== null) {
    var quill = new Quill(quillHook, {
      modules: {
        formula: false,
        syntax: false,
        toolbar: "#toolbar"
      },
      placeholder: "Enter Text ...",
      theme: "snow"
    });
  }

  /*======== MULTIPLE SELECT ========*/
  var select2Multiple = $(".js-example-basic-multiple");
  if (select2Multiple.length != 0){
    select2Multiple.select2();
  }
  var select2Country = $(".country");
  if (select2Country.length != 0){
    select2Country.select2({
      minimumResultsForSearch: -1
    });
  }


  /*======== LOADING BUTTON ========*/
  var laddaButton = $('.ladda-button');
  if (laddaButton.length != 0){
    Ladda.bind(".ladda-button", {
      timeout: 1000
    });
  }

  /*======== TOASTER ========*/
  // var toaster = $('#toaster')
  // function callToaster(positionClass) {
  //   toastr.options = {
  //     closeButton: true,
  //     debug: false,
  //     newestOnTop: false,
  //     progressBar: true,
  //     positionClass: positionClass,
  //     preventDuplicates: false,
  //     onclick: null,
  //     showDuration: "300",
  //     hideDuration: "1000",
  //     timeOut: "5000",
  //     extendedTimeOut: "1000",
  //     showEasing: "swing",
  //     hideEasing: "linear",
  //     showMethod: "fadeIn",
  //     hideMethod: "fadeOut"
  //   };
  //   toastr.success("Welcome to Mono Dashboard", "Howdy!");
  // }

  // if (toaster.length != 0) {

  //   if (document.dir != "rtl") {
  //     callToaster("toast-top-right");
  //   } else {
  //     callToaster("toast-top-left");
  //   }

  // }

  // /*======== INFO BAR ========*/
  // var infoTeoaset = $('#toaster-info, #toaster-success, #toaster-warning, #toaster-danger');
  // if (infoTeoaset !== null){
  //   infoTeoaset.on('click', function () {
  //     console.log("asas");
  //     toastr.options = {
  //       closeButton: true,
  //       "debug": false,
  //       "newestOnTop": false,
  //       "progressBar": false,
  //       "positionClass": "toast-top-right",
  //       "preventDuplicates": false,
  //       "onclick": null,
  //       "showDuration": "3000",
  //       "hideDuration": "1000",
  //       "timeOut": "5000",
  //       "extendedTimeOut": "1000",
  //       "showEasing": "swing",
  //       "hideEasing": "linear",
  //       "showMethod": "fadeIn",
  //       "hideMethod": "fadeOut"
  //     }
  //     var thisId = $(this).attr('id');
  //     if ( thisId === 'toaster-info') {
  //       toastr.info("Welcome to Mono", " Info message");

  //     } else if ( thisId === 'toaster-success') {
  //       toastr.success("Welcome to Mono", "Success message");

  //     } else if ( thisId === 'toaster-warning') {
  //       toastr.warning("Welcome to Mono", "Warning message");

  //     } else if ( thisId === 'toaster-danger') {
  //       toastr.error("Welcome to Mono", "Danger message");
  //     }

  //   });
  // }

  /*======== DATA TABLE ========*/
  var productsTable = $('#productsTable');
  if (productsTable.length != 0){
    productsTable.DataTable({
      "info": false,
      "lengthChange": false,
      "lengthMenu": [[5, 10, 15, -1], [5, 10, 15, "All"]],
      "scrollX": true,
      "order": [[2, "asc"]],
      "columnDefs": [{
        "orderable": false,
        "targets": [, 0, 6, -1]
      }],
      "language": {
        "search": "_INPUT_",
        "searchPlaceholder": "Search..."
      }
    });
  }

  var productSale = $('#product-sale');
  if (productSale.length != 0){
    productSale.DataTable({
      "info": false,
      "paging": false,
      "searching": false,
      "scrollX": true,
      "order": [[0, "asc"]],
      "columnDefs": [{
        "orderable": false,
        "targets": [-1]
      }],
    });
  }

  /*======== OWL CAROUSEL ========*/
  var slideOnly = $(".slide-only");
  if (slideOnly.length != 0){
    slideOnly.owlCarousel({
      items: 1,
      autoplay: true,
      loop: true,
      dots: false,
    });
  }

  var carouselWithControl = $(".carousel-with-control");
  if (carouselWithControl.length != 0){
    carouselWithControl.owlCarousel({
      items: 1,
      autoplay: true,
      loop: true,
      dots: false,
      nav: true,
      navText: ['<i class="mdi mdi-chevron-left"></i>', '<i class="mdi mdi-chevron-right"></i>'],
      center: true
    });
  }

  var carouselWithIndicators = $(".carousel-with-indicators");
  if (carouselWithIndicators.length != 0){
    carouselWithIndicators.owlCarousel({
      items: 1,
      autoplay: true,
      loop: true,
      nav: true,
      navText: ['<i class="mdi mdi-chevron-left"></i>', '<i class="mdi mdi-chevron-right"></i>'],
      center: true
    });
  }

  var caoruselWithCaptions = $(".carousel-with-captions");
  if (caoruselWithCaptions.length != 0){
    caoruselWithCaptions.owlCarousel({
      items: 1,
      autoplay: true,
      loop: true,
      nav: true,
      navText: ['<i class="mdi mdi-chevron-left"></i>', '<i class="mdi mdi-chevron-right"></i>'],
      center: true
    });
  }

  var carouselUser = $(".carousel-user");
  if (carouselUser.length != 0){
    carouselUser.owlCarousel({
      items: 4,
      margin: 80,
      autoplay: true,
      loop: true,
      nav: true,
      navText: ['<i class="mdi mdi-chevron-left"></i>', '<i class="mdi mdi-chevron-right"></i>'],
      responsive: {
        0: {
          items: 1,
          margin: 0,
        },
        768: {
          items: 2,
        },
        1000: {
          items: 3,
        },
        1440: {
          items: 4,
        },
      }
    });
  }

  var carouselTestimonial = $(".carousel-testimonial");
  if (carouselTestimonial.length != 0){
    carouselTestimonial.owlCarousel({
      items: 3,
      margin: 135,
      autoplay: false,
      loop: true,
      nav: true,
      navText: ['<i class="mdi mdi-chevron-left"></i>', '<i class="mdi mdi-chevron-right"></i>'],
      responsive: {
        0: {
          items: 1,
          margin: 0,
        },
        768: {
          items: 1,
        },
        1000: {
          items: 2,
        },
        1440: {
          items: 3,
        },
      }
    });
  }

  /*======== CIRCLE PROGRESS ========*/
  var circle = $('.circle')
  var gray = '#f5f6fa';

  if(circle.length != 0){
    circle.circleProgress({
      lineCap: "round",
      startAngle: 4.8,
      emptyFill: [gray]
    })
  }
});

$(document).on('turbolinks:load', function() {
  /*======== PROGRESS BAR ========*/
  NProgress.done();
});
