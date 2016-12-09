function createMap () {
  var mapEl = document.querySelector('#map');
  var map = new google.maps.Map(mapEl, {
    zoom: 3,
    center: {
      lat: -28.024, 
      lng: 140.887
    }
  });

  // Create an array of alphabetical characters used to label the markers.
  var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Add some markers to the map.
  var markers = locations.map(function (location, i) {
    return new google.maps.Marker({
      position: location,
      label: labels[i % labels.length]
    });
  });
}


