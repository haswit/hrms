import 'package:location/location.dart';

Location location = Location();

Future<bool> requestLocation() async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();

    if (!_serviceEnabled) {
      return false;
    } else {
      return true;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    } else {
      return true;
    }
  }
  return true;
  //_locationData = await location.getLocation();
}
