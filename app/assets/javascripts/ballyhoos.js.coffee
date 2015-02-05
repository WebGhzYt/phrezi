$(document).on 'change', '#checkin_ballyhoo_audience', ->
  include_friend = $(this).val()
  parent_div = $(this).parents('div.checkin_ballyhoo_audience')
  if include_friend == '1'
    parent_div.siblings('div.checkin_ballyhoo_total_checkin_qty').removeClass 'hide'
  else
    parent_div.siblings('div.checkin_ballyhoo_total_checkin_qty').addClass 'hide'
  return

$(document).on "click", "#manual_check_in", ->
  user_id = $("#user_id option:selected").val()
  $.ajax
    url: "/checkin_ballyhoos/manual_checkin"
    type: "GET"
    data:
      user_id: user_id

    success: ->
      window.location.reload()
      return

  return

$(document).on "click", "#manual_check_out", ->
  user_id = $("#user_id option:selected").val()
  $.ajax
    url: "/checkin_ballyhoos/manual_checkout"
    type: "GET"
    data:
      user_id: user_id

    success: ->
      window.location.reload()
      return

  return

#booster datepickers
$(document).ready ->
  path = window.location.pathname
  if path is "/" or path is "/challenges"
    $("input.datepicker-start").datetimepicker
      format: "DD-MM-YYYY"
      pickTime: false
      minDate: Date()
    
    $("input.datepicker-start").data("DateTimePicker").setDate new Date()
    
    set_check_date = $("#check_start_date").val()
    $("#check_end_date").val set_check_date
    
      
    $("input.timepicker-start").datetimepicker
      format: "HH:mm"
      pickDate: false
      
    $("input.timepicker-end").datetimepicker
      format: "HH:mm"
      pickDate: false
      
    #$("input.timepicker-start").on "dp.change", (e) ->
      #$("input.timepicker-end").data("DateTimePicker").setMinDate e.date
      #return

    #$("input.timepicker-end").on "dp.change", (e) ->
      #$("input.timepicker-start").data("DateTimePicker").setMaxDate e.date
      #return
  return

$(document).on "focusout", "#check_start_date", ->
  set_check_date = $("#check_start_date").val()
  $("#check_end_date").val set_check_date
  return


# Repeat-model
$(document).ready ->
  $(".dp").datepicker({
    format: "dd-mm-yyyy"
  })
  $(".disabled-row .form-control").attr "disabled", true
  $("select#ballyhoo_ballyhoo_day_attributes_repeat_type").change(->
    $("select#ballyhoo_ballyhoo_day_attributes_repeat_type option:selected").each ->
      if $(this).attr("value") is "0"
        $(".weekly_days").hide()
        $('.repeat_text_modal').text('Daily')
      if $(this).attr("value") is "1"
        $(".weekly_days").show()
        $('.repeat_text_modal').text('Weekly')
      return

    return
  ).change()
  return

$(document).on "click", ".week_day", ->
  week_day = parseInt($(this).attr('id').split('_').pop())
  day_value = $('#ballyhoo_ballyhoo_day_attributes_day').val()
  if $(this).prop('checked') is true
    day_val = replaceAt(day_value, week_day, 'T')
  else if $(this).prop('checked') is false
    day_val = replaceAt(day_value, week_day, 'F')
  $('#ballyhoo_ballyhoo_day_attributes_day').val day_val
  return

$(document).on "click", "#save_ballyhoo_day_btn", ->
  if $('#ballyhoo_ballyhoo_day_attributes_repeat_type').val() is "1"
    if $('.week_day:checked').length is 0
      alert('Select a week day')
    else
      $('#modal-repeat').modal('hide')
      $('.repeat_text').text('Weekly')
  else
    $('#modal-repeat').modal('hide')
    $('.repeat_text').text('Daily')

$(document).on "focusout", ".repeat_days",  ->
  if $('#end_date_btn_After').prop('checked') is true
    if $("#after_days").val() isnt ""
      today = new Date()
      after_date = parseInt($('#after_days').val())
      d = today.getTime()+ (24*60*60*1000*after_date)
      date_value = new Date(d);
      $("#ballyhoo_ballyhoo_day_attributes_end_repeat").val [
        date_value.getDate().padLeft()
        (date_value.getMonth() + 1).padLeft()
        date_value.getFullYear()
      ].join("-")
      $('#on_day').val ""
  else if $('#end_date_btn_On').prop('checked') is true
    date_value = $('#on_day').val()
    $("#ballyhoo_ballyhoo_day_attributes_end_repeat").val date_value
    $("#after_days").val ""

#For Ballyhoo all day
$(document).on "change", "#ballyhoo_ballyhoo_all_day", ->
  if $(this).prop("checked") is true
    $("div.task_time").addClass "hide"
    $('#task_start, #task_end').val '00:00'
  else
    $("div.task_time").removeClass "hide"
    $('#task_start, #task_end').val ''
  return

#For Ballyhoo include friend
#$(document).on "change", "#check_audience", ->
#  value = $("#check_audience option:selected").text()
  #if value is "Include Friends"
    #$("div.friend_qty").removeClass "hide"
  #else
    #$("div.friend_qty").addClass "hide"
  #return




Number::padLeft = (base, chr) ->
  len = (String(base or 10).length - String(this).length) + 1
  (if len > 0 then new Array(len).join(chr or "0") + this else this)
