$(document).ready(function() {
  if (!$('#maps-data')) {
    return;
  }

  handler = Gmaps.build('Google');
  handler.buildMap({
    provider: {},
    internal: {
      id: 'map'
    }
  }, function() {
    var data = JSON.parse($('#maps-data').text());
    var markers = handler.addMarkers(data);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  });
});
