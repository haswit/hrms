import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as tk;
import '../views/gps_alert.dart';

class LocationService {
  LocationService();
  Location currentLocation = Location();
  late bool _serviceEnabled;
  bool inLoginZone = false;
  late PermissionStatus _permissionGranted;

  void getLocation(context) async {
    // currentLocation.enableBackgroundMode(enable: true);
    _serviceEnabled = await currentLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await currentLocation.requestService();

      if (!_serviceEnabled) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      }
    }

    _permissionGranted = await currentLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await currentLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      }
    }
  }

  getAltitude() async {
    var location = await currentLocation.getLocation();
    return location.altitude!.toDouble();
  }

  bool userInRarius(latitude, longitude, innerRadius, l) {
    final distance = tk.SphericalUtil.computeDistanceBetween(
        tk.LatLng(latitude, longitude), l);

    return distance < innerRadius;
  }

  onLocationChangedListner(mapController, latitude, longitude, innerRadius) {
    currentLocation.onLocationChanged.listen((LocationData loc) async {
      mapController
          // ignore: unnecessary_new
          .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      bool x = userInRarius(latitude, longitude, innerRadius,
          tk.LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble()));

      if (x) {
        inLoginZone = true;
      } else {
        //NotifyUser("Please move into Login zone to enter the attendance");
        inLoginZone = false;
      }
    });
  }
}
