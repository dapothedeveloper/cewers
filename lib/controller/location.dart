import 'package:cewers/model/user-location.dart';
import 'package:location/location.dart';

class GeoLocationController {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<UserCoordinateModel> getCoordinates() async {
    _serviceEnabled = await location.serviceEnabled();
    try {
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print("Not granded");
          return UserCoordinateModel(null, null, "No location service enabled");
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return UserCoordinateModel(
              null, null, "Location permission not granted");
        }
      }

      _locationData = await location.getLocation();

      return UserCoordinateModel(
          _locationData.latitude, _locationData.longitude, null);
    } catch (e) {
      return UserCoordinateModel(null, null, e);
    }
  }

  Future<void> promptRequestLocationPerssion() async {
    _serviceEnabled = await location.serviceEnabled();
    try {
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }
    } catch (e) {}
  }

  Future<bool> getLocationPerssionStatus() async {
    return await location.serviceEnabled();
  }
}
