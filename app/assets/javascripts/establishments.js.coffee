map = document.getElementById('address-map')
if map
  geocoder = new google.maps.Geocoder()

  updateGpsCoords = (location) ->
    $('#establishment_gps_lat').val(location.lat())
    $('#establishment_gps_long').val(location.lng())
  mapOptions =
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 17
  map = new google.maps.Map(document.getElementById('address-map'), mapOptions)
  marker = new google.maps.Marker
    map: map
    draggable: true

  if typeof gon != 'undefined' && gon.location
    location = new google.maps.LatLng(gon.location.lat, gon.location.lng)
    marker.setPosition(location)
    map.setCenter(location)

  ids = _.map(['street1', 'street2', 'city', 'province', 'country'], (i) -> "#establishment_address_attributes_#{i}")

  $(document).on "focusout", ".address-form", ->
    address = _.compact(_.map(['#establishment_name'].concat(ids), (i) -> $(i).val())).join(',')
    geocoder.geocode( {address: address}, (result, status) ->
      if status == google.maps.GeocoderStatus.OK
        marker.setPosition(result[0].geometry.location)
        map.panTo(marker.position)
        map.fitBounds(result[0].geometry.viewport)
    )

  marker.addListener('position_changed', ->
    updateGpsCoords(marker.position)
  )


  $("#update_establishment_btn").click ->
    laTlnG = new google.maps.LatLng($('#establishment_gps_lat').val(), $('#establishment_gps_long').val())
    geocoder.geocode latLng: laTlnG , (result, status) ->
      if status == google.maps.GeocoderStatus.OK
        #marker.setPosition(result[0].geometry.location)
        #map.panTo(marker.position)
        #map.fitBounds(result[0].geometry.viewport)
        $('#establishment_form').ajaxForm().submit()
      else
        $.ajax
          url: "/establishments/check_map_position"
          data:
            message: "Failed to geolocate you. Please adjust your marker manually."
            establishment_id: $("#establishment_id").val()


$(document).ready ->
  preview = $(".upload_preview img")
  $("#establishment_picture").change (event) ->
    input = $(event.currentTarget)
    file = input[0].files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      image_base64 = e.target.result
      preview.attr "src", image_base64
      return

    reader.readAsDataURL file
    return

  return

$("#upload_btn").click ->
  $("#establishment_picture").click()
  return

$(document).on "change", "#closed", ->
  closest_input = $(this).siblings("input")
  if $(this).is(":checked") is true
    closest_input.prop "readonly", true
    #$("input.timepicker").data("DateTimePicker").disable()
    closest_input.prop "disabled", true
    closest_input.removeClass('timepicker')
  else if $(this).is(":checked") is false
    closest_input.addClass('timepicker')
    closest_input.prop "disabled", false
    closest_input.prop "readonly", false
    $("input.timepicker").datetimepicker
      format: "HH:mm"
      pickDate: false
  return

$ ->
  $("input.timepicker").datetimepicker
    format: "HH:mm"
    pickDate: false

  return

$(document).on "click", "#map_error_btn", ->
  $("#map-flash-popup").modal("hide")
  return

$("#establishment").modal "show"  if typeof establishment_modal isnt "undefined"


$("#establishment-pop-up").click ->
  $("#establishment").modal "hide"
  return
