$(document).ready(function(){
  $('#menu_items_validations').validate();
})
function delete_menu_item(element)
{
  window.element = element
  $('#delete-menu-item-confirm').modal('show');
}
$('#menu-item-delete').click(function(){
  var element = window.element
  $('#delete-menu-item-confirm').modal('hide');
  id = $(element).attr("id")
  $.ajax({
    url: '/menu_items/'+id,
    type: "DELETE"
  // }).done(function(response){
  //   //$('.fade').removeClass("modal-backdrop");
  //   $('#menu_items').html(response)
  //   datatable()
  });
});
