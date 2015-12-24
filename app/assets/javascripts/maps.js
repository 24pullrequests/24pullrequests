document.addEventListener("DOMContentLoaded", function(event) {
  function hasLatLng(marker) {
    return marker.lat && marker.lng;
  }

  var mapMarkers = document.getElementById('maps-data');

  if (!mapMarkers) {
    return;
  }

  handler = Gmaps.build('Google');
  handler.buildMap({
    provider: {},
    internal: {
      id: 'map'
    }
  }, function() {
    var data = JSON.parse(mapMarkers.innerHTML).filter(hasLatLng),
        markers = handler.addMarkers(data);

    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  });
});
