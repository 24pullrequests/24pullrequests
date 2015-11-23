document.addEventListener("DOMContentLoaded", function(event) {
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
    var data = JSON.parse(mapMarkers.innerHTML);
    var markers = handler.addMarkers(data);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  });
});
