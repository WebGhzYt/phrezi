$(document).on 'click', '[data-href]', ->
  window.location = $(this).data('href')

$(document).on "click", "#booster_btn", ->
  $("div.challenge-setup-wrap").toggleClass "hide"
  $("div.booster").toggleClass "hide"
  return

$(document).on "click", "#challenge-btn", ->
  $("div.challenge-setup-wrap").toggleClass "hide"
  $("div.booster").toggleClass "hide"
  return
 
  $('input.copied_start_date').datepicker("setDate", new Date());

  $('.thetooltip').tooltip()

$(document).ready ->
  path = window.location
  $("#challenge-setup").modal "show"  if path.href.split("/")[3] is "challenges?setup=true"
  $("#collapseTwo").addClass "in" if path.href.split("/")[3] is "challenges?setup=true"
  $("#establishment").modal "show" if path.pathname is "/establishments/new"
  return


$(document).ready ->
  if window.location.href.split("/")[3] is "challenges?active=true&first=true"
    $("#collapseTwo").removeClass "in"
    $("#collapseOne").addClass "in"
    $("#challenge-active").modal "show"
  else

  if window.location.href.split("/")[3] is "challenges?active=true&first=false"
    $("#collapseTwo").removeClass "in"
    $("#collapseOne").addClass "in"
    $("#challenge-active").modal "show"
  else

  #Tooltip
  $("[data-toggle='tooltip']").tooltip()
  
  #Accordion
  $(".collapse").on("shown.bs.collapse", ->
    $(this).parent().find(".btn-default").removeClass("hide").addClass "visible"
    return
  ).on "hidden.bs.collapse", ->
    $(this).parent().find(".btn-default").removeClass("visible").addClass "hide"
    return

  return

#For challenge-setup page
$ ->
    start_next_day = $("#challenge_start_date").val()
    end_next_day = $("#challenge_end_date").val()
    $("input.datetimepicker-start").datetimepicker
      format: "YYYY-MM-DD"
      pickTime: false
      minDate: Date() 

    $("input.datetimepicker-end").datetimepicker
      format: "YYYY-MM-DD"
      pickTime: false
      minDate: Date()
      
    $("input.datetimepicker-start").on "dp.change", (e) ->
      $('input.datetimepicker-end').data("DateTimePicker").setMinDate e.date;
      return
    
    $("input.datetimepicker-end").on "dp.change", (e) ->
      $('input.datetimepicker-start').data("DateTimePicker").setMaxDate e.date;
      return
  
