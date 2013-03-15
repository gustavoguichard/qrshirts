jQuery(document).ready(function ($) {
  $('a.product_name', '#inventory_table').on('click', function(e){
    e.preventDefault();
    $tr = $(e.target).closest('tr');
    $('table.variants', $tr).fadeToggle();
  })
});