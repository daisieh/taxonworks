$(document).ready(function() {
  if($("#filter").length) {
    initFilterBar();
  }
});

function initFilterBar() {
	$('[data-filter-category="taxon_name"]').prepend('<img src="/assets/icons/new.svg"/>');
	$('[data-filter-category="source"]').prepend('<img src="/assets/icons/book.svg"/>');
	$('[data-filter-category="collection_object"]').prepend('<img src="/assets/icons/picking.svg"/>');
	$('[data-filter-category="collecting_event"]').prepend('<img src="/assets/icons/geo_location.svg"/>');	

  function deactivateBackgroundColorLink(selector) {
  $(selector).removeClass("activated");
  }

  function activateBackgroundColorLink(selector) {
    $(selector).addClass("activated");
  }

  function changeBackgroundColorLink(selector) {
    if ($(selector).hasClass("activated")) {
      deactivateBackgroundColorLink(selector);
    }
    else {
      activateBackgroundColorLink(selector);
      }
  }
   $('#filter [data-filter-category]').on('click', function() {
    changeBackgroundColorLink('[data-filter-category="'+ $(this).attr("data-filter-category") +'"]');
   }); 

  $('#filter [data-filter-category="reset"]').on('click', function() {
      deactivateBackgroundColorLink('[data-filter-category]');
  });     
}
