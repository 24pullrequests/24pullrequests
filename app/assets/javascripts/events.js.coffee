class Map
  setupPicker: (latitude, longitude) ->
    if $(@mapElement).data('map-picker')
      @pin = new ol.Overlay(
        position: ol.proj.transform([longitude,latitude], 'EPSG:4326', 'EPSG:3857')
        element: $('.pin')[0]
      )

      @map.addOverlay(@pin)

      @setForm(latitude, longitude)

      @map.on "click", (evt) =>
        console.log evt
        coordinate = evt.coordinate
        @pin.setPosition(evt.coordinate)
        latlng = ol.proj.transform(coordinate, 'EPSG:3857', 'EPSG:4326');
        @setForm(latlng[0], latlng[1])

  setForm: (latitude, longitude) ->
    $('#event_longitude').val latitude
    $('#event_latitude').val longitude

  zoomTo: (latitude, longitude, zoom = 12) ->
    @view.setCenter(ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"))
    @view.setZoom(zoom)

  locationSuccess: (position) =>
    @zoomTo(position.coords.latitude, position.coords.longitude)
    @setupPicker(position.coords.latitude, position.coords.longitude)

  locationFail: (err) =>
    @setupPicker(0,0)

  setLocationToGeolocation: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition @locationSuccess, @locationFail
    else
      @locationFail()

  constructor: (@mapElement) ->
    @view = new ol.View(
      center: ol.proj.transform([0,18], "EPSG:4326", "EPSG:3857")
      zoom: 2
    )

    @map = new ol.Map(
      layers: [
        new ol.layer.Tile(source: new ol.source.OSM())
      ]
      target: @mapElement
      view: @view
    )

    latitude = $(@mapElement).data('latitude')
    longitude = $(@mapElement).data('longitude')

    if latitude? and longitude?
      latitude = parseFloat(latitude, 10)
      longitude = parseFloat(longitude, 10)
      @zoomTo(latitude, longitude, 14)
      @setupPicker(latitude, longitude)
    else
      @setLocationToGeolocation()

$ ->

  allowTimes =  []
  currentYear = (new Date()).getFullYear().toString()

  for hour in [0..23]
    for quarter in ["00", "15", "30", "45"]
      allowTimes.push "#{hour}:#{quarter}"

  # @TODO:
  $('.js-datetimepicker').datetimepicker(
    minDate: currentYear + '/12/01'
    maxDate: currentYear + '/12/25'
    startDate: currentYear + '/12/01'
    allowTimes: allowTimes
  )

  $('.js-contribution-datetimepicker').datetimepicker(
    minDate: currentYear + '/12/01'
    maxDate: currentYear + '/12/24'
    startDate: currentYear + '/12/01'
    allowTimes: allowTimes
  )

  $('.map').each ->

    map = new Map(@)

    $('.js-pins .pin').each ->
      latitude = $(@).data('latitude')
      longitude = $(@).data('longitude')

      if latitude? and longitude?
        latitude = parseFloat(latitude, 10)
        longitude = parseFloat(longitude, 10)
        overlay = new ol.Overlay(
          position: ol.proj.transform([longitude,latitude], 'EPSG:4326', 'EPSG:3857')
          element: @
        )
        map.map.addOverlay(overlay)

  if $('.toggle-past-events').length
    $('.toggle-past-events').click (evt) =>
      pastEvents = $('.past-events')
      spanTxt = $('.toggle-past-events').children('span')

      if pastEvents.hasClass('hidden')
        pastEvents.removeClass('hidden')
        spanTxt.text('Hide')
      else
        pastEvents.addClass('hidden')
        spanTxt.text('Show')
