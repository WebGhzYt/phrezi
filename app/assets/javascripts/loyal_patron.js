$(document).ready(function(){
    $('#patrons-table').DataTable({
      "paging":   false
    });
    //styling and remove classes from table.
    $('#patrons-table_length').hide();
    $('#patrons-table_filter').hide();
    $('#patrons-table_info').hide();
    $('#patrons-table_paginate').hide();
});


function show_loyal_patron(element){
  id = $(element).attr("id")
  $.ajax({
    url: '/loyal_patrons/'+id,
    type: "GET"
  });
}