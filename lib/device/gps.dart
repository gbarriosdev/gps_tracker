import 'package:geolocator/geolocator.dart';

class GpsSensor {
  Future<LocationPermission> get permissionStatus async =>
      await Geolocator.checkPermission();

  Future<Position> get currentLocation async =>
      await Geolocator.getCurrentPosition();

  Future<LocationAccuracyStatus> get locationAccuracy async =>
      await Geolocator.getLocationAccuracy();

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
