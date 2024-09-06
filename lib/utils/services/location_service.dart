import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> isLocationEnabled() async {
    LocationPermission permission = await Geolocator.checkPermission();

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
