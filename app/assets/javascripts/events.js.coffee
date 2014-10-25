class Map

  zoomTo: (latitude, longitude, zoom = 12) ->
    @view.setCenter(ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"))
    @view.setZoom(zoom)

  setLocationToGeolocation: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @zoomTo(position.coords.latitude, position.coords.longitude)

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

      console.log latitude, longitude
      @zoomTo(latitude, longitude, 14)
    else
      @setLocationToGeolocation()

$ ->

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
