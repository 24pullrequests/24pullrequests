(function() {
  function EventMap(mapElement) {
    this.mapElement = mapElement;
    this.view = new ol.View({
      center: ol.proj.transform([0, 18], "EPSG:4326", "EPSG:3857"),
      zoom: 2
    });

    this.map = new ol.Map({
      layers: [
        new ol.layer.Tile({ source: new ol.source.OSM() })
      ],
      target: this.mapElement,
      view: this.view
    });

    var latitude = $(this.mapElement).data("latitude");
    var longitude = $(this.mapElement).data("longitude");

    if (latitude != null && longitude != null) {
      latitude = parseFloat(latitude, 10);
      longitude = parseFloat(longitude, 10);
      this.zoomTo(latitude, longitude, 14);
      this.setupPicker(latitude, longitude);
    } else {
      this.setLocationToGeolocation();
    }
  }

  EventMap.prototype.setupPicker = function(latitude, longitude) {
    var self = this;

    if ($(this.mapElement).data("map-picker")) {
      this.pin = new ol.Overlay({
        position: ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"),
        element: $(".pin")[0]
      });

      this.map.addOverlay(this.pin);

      this.setForm(longitude, latitude);

      this.map.on("click", function(evt) {
        var coordinate = evt.coordinate;
        self.pin.setPosition(evt.coordinate);
        var lonlat = ol.proj.transform(coordinate, "EPSG:3857", "EPSG:4326");
        self.setForm(lonlat[0], lonlat[1]);
      });
    }
  };

  EventMap.prototype.setForm = function(longitude, latitude) {
    $("#event_longitude").val(longitude);
    $("#event_latitude").val(latitude);
  };

  EventMap.prototype.zoomTo = function(latitude, longitude, zoom) {
    if (zoom == null) {
      zoom = 12;
    }

    this.view.setCenter(ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"));
    this.view.setZoom(zoom);
  };

  EventMap.prototype.locationSuccess = function(position) {
    this.zoomTo(position.coords.latitude, position.coords.longitude);
    this.setupPicker(position.coords.latitude, position.coords.longitude);
  };

  EventMap.prototype.locationFail = function() {
    this.setupPicker(0, 0);
  };

  EventMap.prototype.setLocationToGeolocation = function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this.locationSuccess.bind(this),
        this.locationFail.bind(this)
      );
    } else {
      this.locationFail();
    }
  };

  $(function() {
    var allowTimes = [];
    var currentYear = (new Date()).getFullYear().toString();
    var quarters = ["00", "15", "30", "45"];

    for (var hour = 0; hour <= 23; hour++) {
      for (var i = 0; i < quarters.length; i++) {
        allowTimes.push(hour + ":" + quarters[i]);
      }
    }

    function configureDateTimePicker(selector, maxDate) {
      $(selector).datetimepicker({
        minDate: currentYear + "/12/01",
        maxDate: maxDate,
        startDate: currentYear + "/12/01",
        allowTimes: allowTimes
      });
    }

    configureDateTimePicker(".js-datetimepicker", currentYear + "/12/25");
    configureDateTimePicker(".js-contribution-datetimepicker", currentYear + "/12/24");

    $(".map").each(function() {
      var map = new EventMap(this);

      $(".js-pins .pin").each(function() {
        var latitude = $(this).data("latitude");
        var longitude = $(this).data("longitude");

        if (latitude != null && longitude != null) {
          latitude = parseFloat(latitude, 10);
          longitude = parseFloat(longitude, 10);

          var overlay = new ol.Overlay({
            position: ol.proj.transform([longitude, latitude], "EPSG:4326", "EPSG:3857"),
            element: this
          });

          map.map.addOverlay(overlay);
        }
      });
    });

    if ($(".toggle-past-events").length) {
      $(".toggle-past-events").click(function() {
        var pastEvents = $(".past-events");
        var spanTxt = $(".toggle-past-events").children("span");

        if (pastEvents.hasClass("hidden")) {
          pastEvents.removeClass("hidden");
          spanTxt.text("Hide");
        } else {
          pastEvents.addClass("hidden");
          spanTxt.text("Show");
        }
      });
    }
  });
}());
