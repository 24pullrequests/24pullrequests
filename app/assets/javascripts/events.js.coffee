class Map

  setupPicker: (latitude, longitude) ->

    @pin = new ol.Overlay(
      position: ol.proj.transform([longitude,latitude], 'EPSG:4326', 'EPSG:3857')
      element: $('.pin')[0]
    )

    @map.addOverlay(@pin)

    @map.on "click", (evt) =>
      console.log evt
      coordinate = evt.coordinate
      @pin.setPosition(evt.coordinate)
      latlng = ol.proj.transform(coordinate, 'EPSG:3857', 'EPSG:4326');
      $('#event_longitude').val latlng[0]
      $('#event_latitude').val latlng[1]

  zoomTo: (latitude, longitude, zoom = 12) ->
    @view.setCenter(ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"))
    @view.setZoom(zoom)

  setLocationToGeolocation: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @zoomTo(position.coords.latitude, position.coords.longitude)
        @setupPicker(position.coords.latitude, position.coords.longitude) if $(@mapElement).data('map-picker')
    else
      @setupPicker(0,0) if $(@mapElement).data('map-picker')

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
      @setupPicker(latitude, longitude) if $(@mapElement).data('map-picker')
    else
      @setLocationToGeolocation()

$ ->

  allowTimes =  []
  for hour in [0..23]
    for quarter in ["00", "15", "30", "45"]
      allowTimes.push "#{hour}:#{quarter}"

  $('.js-datetimepicker').datetimepicker(
    minDate:'2014/12/01'
    maxDate:'2014/12/24'
    startDate:'2014/12/01'
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
