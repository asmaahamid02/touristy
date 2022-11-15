import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHandler {
  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address = '';

      if (place.locality != null) {
        address = place.locality!;
      }

      if (place.subAdministrativeArea != null) {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += place.subAdministrativeArea!;
      }

      if (place.country != null) {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += place.country!;
      }
      return address;
    } catch (error) {
      return error.toString();
    }
  }
}
