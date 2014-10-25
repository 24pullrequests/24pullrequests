class Map
  constructor: ->
    @view = new ol.View(
      center: ol.proj.transform([0,18], "EPSG:4326", "EPSG:3857")
      zoom: 2
    )

    @map = new ol.Map(
      layers: [
        new ol.layer.Tile(source: new ol.source.OSM())
      ]
      target: document.getElementById("map")
      view: @view
    )

$ ->
  map = new Map

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

  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
      map.view.setCenter(ol.proj.transform([position.coords.longitude, position.coords.latitude], "EPSG:4326", "EPSG:3857"))
      map.view.setZoom(13)
