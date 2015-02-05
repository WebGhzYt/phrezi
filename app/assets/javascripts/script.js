


$('document').ready(function() { 

  // $('#modal-schedule').modal('show');
  //Tooltip
  $("[data-toggle='tooltip']").tooltip();

  //Accordion Custom
  $('.collapse').on('shown.bs.collapse', function(){
    $(this).parent().find(".btn-default").removeClass("hide").addClass("visible");
  }).on('hidden.bs.collapse', function(){
    $(this).parent().find(".btn-default").removeClass("visible").addClass("hide");
  });


  // // Calendar
 
  // var date = new Date();
  // var d = date.getDate();
  // var m = date.getMonth();
  // var y = date.getFullYear();
  // path = window.location.pathname
  // if ((path == "/" || path == "/challenges") && (typeof show_event_on_calender !== "undefined")){
  //   var calendar = $('#calendar').fullCalendar({
  //     eventLimit: {
  //       'month': 2
  //     },
  //     eventLimitText: "Boosters",
  //     // header: {
  //     //   left: 'prev,next today',
  //     //   center: 'title',
  //     //   right: 'month,agendaWeek,agendaDay'
  //     // },
  //     defaultDate: date,
  //     selectable: true,
  //     selectHelper: true,
  //     /*select: function(start, end, allDay) {
  //     var title = prompt('Event Title:');
  //     if (title) {
  //       calendar.fullCalendar('renderEvent',
  //       {
  //         title: title,
  //         start: start,
  //         end: end,
  //         allDay: allDay
  //       },
  //       true // make the event "stick"
  //       );
  //     }
  //     calendar.fullCalendar('unselect');
  //   },*/
  //     editable: false,
  //     events: [
  //       /*{
  //       title: 'Event',
  //       start: new Date(start_date)
  //       }*/
  //       {
  //         title: "Active Challenge",
  //         start: start_date,
  //         end: end_date,
  //         backgroundColor: '#6ab5d5 !important',
  //       },
  //       {
  //         title: 'Upcoming Challenge',
  //         start: upcoming_start_date,
  //         end: upcoming_end_date,
  //         backgroundColor: '#DCB074 !important',
  //         borderColor: '#DCB074 !important',
  //       }
  //     ],
  //     dayClick: function(date, jsEvent, view) {
  //       var moment = date.toString().split(/\s+/);
  //       $('#calender_date_l').html(moment[0]+" "+","+moment[2]+ " " + moment[1] + " " + moment[3] );
  //       date = $('#calender_date_l').html();
  //       $.ajax({
  //         url: '/ballyhoos/show_active_boosters',
  //         type: "GET",
  //         data: {
  //           date:  date
  //         }
  //       }).done(function(response){
  //         $('#active_boosters').html(response);
  //       });
  //     }
  //   });
  // }
  // else
  // {
  //   var calendar = $('#calendar').fullCalendar({
  //     header: {
  //       left: 'prev,next today',
  //       center: 'title',
  //       right: 'month,agendaWeek,agendaDay'
  //     },
  //     selectable: true,
  //     selectHelper: true,
  //     /*select: function(start, end, allDay) {
  //     var title = prompt('Event Title:');
  //     if (title) {
  //       calendar.fullCalendar('renderEvent',
  //       {
  //         title: title,
  //         start: start,
  //         end: end,
  //         allDay: allDay
  //       },
  //       true // make the event "stick"
  //       );
  //     }
  //     calendar.fullCalendar('unselect');
  //   },*/
  //     editable: true,
  //     /*{
  //     title: 'Meeting',
  //     start: new Date(y, m, d, 10, 30),
  //     allDay: false
  //   }*/
  //     dayClick: function(date, jsEvent, view) {

  //       var moment = date.toString().split(/\s+/);
  //       $('#calender_date_l').html(moment[0]+" "+","+moment[2]+ " " + moment[1] + " " + moment[3] );
  //       date = $('#calender_date_l').html();
  //       $.ajax({
  //         url: '/ballyhoos/show_active_boosters',
  //         type: "GET",
  //         data: {
  //           date:  date
  //         }
  //       }).done(function(response){
  //         $('#active_boosters').html(response);
  //       });
  //     }
  //   });
  // }
  
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    e.preventDefault();
    $(this).tab('show');
    $('#calendar').fullCalendar('render');
  })

  $('#setting-2').on('shown.bs.collapse', function () {
    $('#calendar').fullCalendar('render');
  });
  $('.dp').datepicker();
    
  $('.disabled-row .form-control').attr("disabled", true);


  $('.row-1').hide();
  $('.row-5').hide();
  $('.row-7').hide();

  $("#status-type").change(function() {
    var n = $(this).val();
    switch(n)
    {
      case '1':
        $('.row-1').hide();
        $('.row-5').hide();
        $('.row-2').show();
        $('.row-3').show();
        $('.row-4').show();
        $('.row-6').hide();
        $('.row-7').show();
        $('.disabled-row .form-control').attr("disabled", false);
        $('#check-day').attr("checked",true);
        break;
      case '2':
        $('.row-1').show();
        $('.row-2').hide();
        $('.row-6').show();
        $('.row-7').hide();
        $('.row-3').hide();
        $('.row-4').hide();
        $('.row-5').show();
        $('#check-day').attr("checked",false);
        $('.disabled-row .form-control').attr("disabled", false);
        break;
      case '3':
        $('.row-1').hide();
        $('.row-2').hide();
        $('.row-3').hide();
        $('.row-4').show();
        $('.row-5').show();
        $('.row-6').hide();
        $('.row-7').show();
        $('.disabled-row .form-control').attr("disabled", true);
        $('#check-day').attr("checked",true);
        break;

    }
  });

  // Show/Hide Setting
  $("#setting-1").show();
  $("#setting-2,#setting-3,#setting-4").hide();

  $(".show-setting-1").click(function(){
    $("#setting-1").show();
    $(".show-setting-1").toggleClass("setting-active");
    $(".show-setting-2,.show-setting-3,.show-setting-4").removeClass("setting-active");
    $("#setting-2,#setting-3,#setting-4").hide();
  });

  $(".show-setting-2").click(function(){
    if (!$(this).hasClass("clicked")) {
      load_boosters();
    };
    $(this).addClass('clicked')
    $("#setting-2").show();
    $("#setting-1,#setting-3,#setting-4").hide();
    $(".show-setting-2").toggleClass("setting-active");
    $(".show-setting-1,.show-setting-3,.show-setting-4").removeClass("setting-active");
  });

  $(".show-setting-3").click(function(){
    $("#setting-3").show();
    $(".show-setting-3").toggleClass("setting-active");
    $(".show-setting-2,.show-setting-1,.show-setting-4").removeClass("setting-active");
    $("#setting-2,#setting-1,#setting-4").hide();
  });

  $(".show-setting-4").click(function(){
    $("#setting-4").show();
    $(".show-setting-4").toggleClass("setting-active");
    $(".show-setting-2,.show-setting-3,.show-setting-1").removeClass("setting-active");
    $("#setting-2,#setting-3,#setting-1").hide();
  });

  // Action Show/Hide default sidebar
  $("#projection-box").hide();
  $("#projection-box-1").hide();
  $("#statistic-box").hide();


  $(".sideout-btn").click(function(){
    $(this).toggleClass('show-ct');
    $("#projection-box").toggle();
    $("#projection-box-1").hide();
  });

  $(".sideout-btn-1").click(function(){
    $(this).toggleClass('show-ct');
    $("#projection-box-1").toggle();
    $("#projection-box").hide();
  });

  $(".setting-btn").click(function(){
    $("#projection-box").hide();
    $("#projection-box-1").hide();
    $("#statistic-box").hide();
  })

  $('.sideout-statistic-btn').click(function(){
    $(this).toggleClass('show-ct');
    $("#statistic-box").toggle();
  })

}); 

$(document).ready(function(){
  set_calender_date();
  $('#next_month').click(function(){
    $('#calendar').fullCalendar('next');
    set_calender_date();
  });
  $('#previous_month').click(function(){
    $('#calendar').fullCalendar('prev');
    set_calender_date();
  });
});
$(document).ready(function(){
  set_calender_date();
  $('#next_day').click(function(){
    $('#calendar').fullCalendar('incrementDate', 0, 0, 1);
    set_calender_date();
  });
  $('#previous_day').click(function(){
    $('#calendar').fullCalendar('incrementDate', 0, 0, -1);
    set_calender_date();
  });
});

function set_calender_date()
{
  var moment = $('#calendar').fullCalendar('getDate').toString().split(/\s+/);
  $('#calender_date_u').html(moment[1] + " " + moment[3] );
  $('#calender_date_l').html(moment[0]+" "+","+moment[2]+ " " + moment[1] + " " + moment[3] );
}

// // render booster on calendar
// function load_boosters () {
//   $.ajax({
//     url: '/ballyhoos/all_boosters',
//     dataType: 'json',
//     success: function(response){
//       $.each(response["ballyhoos"], function( index, value ) {
//         $('#calendar').fullCalendar( 'renderEvent', {
//             title: value["title"],
//             start: value["start"]
//           }, true )
//       })
//     }
//   })
// }