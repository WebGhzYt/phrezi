$(document).ready(function(){
  $(".percentage").keydown(function (e) {
    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
      // Allow: Ctrl+A
      (e.keyCode == 65 && e.ctrlKey === true) ||
      // Allow: home, end, left, right
      (e.keyCode >= 35 && e.keyCode <= 39)) {
      // let it happen, don't do anything
      return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
      e.preventDefault();
    }

  });


  $('#challenge_payout').val($('#challenge_payout').val());
  $('#challenge_challenge_winner').val($('#challenge_challenge_winner').val());
  $('#challenge_challenge_prize').val($('#challenge_challenge_prize').val());
  $('#calculate_payout').html(parseFloat($('#challenge_challenge_prize').val()) + parseFloat($('#challenge_payout').val()) + 2 + '%');

  $("#challenge_start_date").datetimepicker({
    format: "DD-MM-YYYY",
    pickTime: false,
    minDate: Date()
  });
});

function append_text_field(element)
{
  if($(element).val().indexOf('%') === -1)
  {
    $('#calculate_payout').html(parseFloat($('#challenge_challenge_prize').val()) + parseFloat($('#challenge_payout').val()) + 2 + '%');
    $(element).val($(element).val());
  }
}

$('#demo2').hide();

$('#challenge-accordion-11').click(function(){
  $('#projection-box').hide();
  $('#projection-box-1').hide();
  $('#demo2').hide();
  $('#demo1').show();
});
$('#challenge-accordion-22').click(function(){
  $('#projection-box').hide();
  $('#projection-box-1').hide();
  $('#demo1').hide();
  $('#demo2').toggle();
});

$('.call-booster').click(function(){
  $('#projection-box').hide();
  $('#projection-box-1').hide();
  $('#statistic-box').hide();
})

$('.call-challenge').click(function(){
  $('#projection-box').hide();
  $('#projection-box-1').hide();
  $('#statistic-box').hide();
})

$(document).on('focusout', "#challenge_duration", function(){
  s_date = $('#challenge_start_date').val()
  if (s_date !== ""){
    duration = $('#challenge_duration').val()
    duration = parseInt(duration)
    if (duration > 0)
    {
      var localTime = new Date();
      // duration = duration - 1
      start_date = new Date(s_date)
      start_date.setMinutes(start_date.getMinutes() + localTime.getTimezoneOffset() - 300);
      e_date = start_date.setDate((start_date.getDate()) + parseInt(duration))
      end_date = new Date(e_date)
      end_date.setMinutes(end_date.getMinutes() + localTime.getTimezoneOffset() - 300);
      // alert(new Date(e_date) + ' ' + localTime.getTimezoneOffset() + ' ' + end_date);
      var displayDate =  end_date.getFullYear() + '-' + ( '0' + (end_date.getMonth()+1) ).slice( -2 ) + '-' + ( '0' + end_date.getDate()).slice(-2);
      $('#display_end_date').html(displayDate)
    }
  }
});

$(document).on('focusout', "#edit_challenge_duration", function(){
  s_date = $('#edit_challenge_start_date').val()
  console.log(s_date)
  if (s_date !== ""){
    duration = $('#edit_challenge_duration').val()
    duration = parseInt(duration)
    if (duration > 0)
    {
      var localTime = new Date();
      // duration = duration - 1
      start_date = new Date(s_date)
      start_date.setMinutes(start_date.getMinutes() + localTime.getTimezoneOffset() - 300);
      e_date = start_date.setDate((start_date.getDate()) + parseInt(duration))
      end_date = new Date(e_date)
      end_date.setMinutes(end_date.getMinutes() + localTime.getTimezoneOffset() - 300);
      // alert(new Date(e_date) + ' ' + localTime.getTimezoneOffset() + ' ' + end_date);
      var displayDate =  end_date.getFullYear() + '-' + ( '0' + (end_date.getMonth()+1) ).slice( -2 ) + '-' + ( '0' + end_date.getDate()).slice(-2);
      $('#edit_display_end_date').html(displayDate)
    }
  }
});

function edit_append_text_field(element)
{
  if($(element).val().indexOf('%') === -1)
  {
    $('#edit_calculate_payout').html(parseFloat($('#edit_challenge_prize').val()) + parseFloat($('#edit_challenge_payout').val()) + 2 + '%');
    $(element).val($(element).val());
  }
}

function challenge_setup_toggle()
{
  $('#challenge-accordion-2').show();
  $('#challenge-accordion-1').hide();
}
function challenge_active_toggle()
{
  $('#challenge-accordion-2').hide();
  $('#challenge-accordion-1').show();
}
function booster_setup_toggle()
{
  $('#booster-accordion-1').hide();
  $('#booster-accordion-2').show();
}
function booster_active_toggle()
{
  $('#booster-accordion-2').hide();
  $('#booster-accordion-1').show();
}

function edit_challenge(element)
{
  id = $(element).attr("id")
  $.ajax({
    url: '/challenges/'+id+'/edit',
    type: "GET"
  });
}
