// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.form
//= require jquery.Jcrop
//= require bootstrap.min
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require underscore
//= require underscore-mixins
//= require moment
//= require holder
//= require script
//= require establishments
//= require employee
//= require menu_item
//= require ballyhoo
//= require ballyhoos
//= require profile
//= require bootstrap-datepicker
//= require bootstrap-datetimepicker
//= require fullcalendar.min
//= require jquery.dataTables
//= require loyal_patron
//= require challenges
//= require category
//= require jquery.remotipart
//= require user
//= require dataTables/jquery.dataTables

/*This function is called on closed time checboxes in establishment form*/

function nearest_select(element)
{
  if ($(element).is(':checked'))
  {
    $('#open_time'+$(element).attr("id")).attr("disabled", true);
    $('#end_time'+$(element).attr("id")).attr("disabled", true);
  }
  else
  {
    $('#open_time'+$(element).attr("id")).attr("disabled", false);
    $('#end_time'+$(element).attr("id")).attr("disabled", false);
  }
}
$('.establishment_closed').each(function(){
  if ($(this).is(':checked'))
  {
    $('#open_time'+$(this).attr("id")).attr("disabled", true);
    $('#end_time'+$(this).attr("id")).attr("disabled", true);
  }
  else
  {
    $('#open_time'+$(this).attr("id")).attr("disabled", false);
    $('#end_time'+$(this).attr("id")).attr("disabled", false);
  }
});


function datatable(){
  $('#menu_items_table').dataTable({
    bFilter: false, 
    bInfo: false,
    // bPaginate: false,
    "aoColumnDefs":[
    {
      "bSortable": false,
      "aTargets": [ 3 ]
    },
    ],
  });
}

$(document).ready(function(){
 datatable()
})

$(document).ready(function(){
  $(document).ajaxError(function( event, jqxhr, settings, thrownError ) {
    alert(jqxhr.status + " " + thrownError + " while requesting page at '" + settings.url + "'" + "\n\n" + jqxhr.responseText);
  });
});
