/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
$(document).ready(function(){
  $('#add-employee-frm').validate();
});

function delete_employee(element){
  if (confirm('Are you sure?')){
    id = $(element).attr("id")
    $.ajax({
      url: '/employees/'+id,
      type: "DELETE"
    }).done(function(response){
      $('#employees').html(response);
    });
  }
}

