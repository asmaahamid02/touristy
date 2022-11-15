import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import './utilities.dart';

class LocationHandler {
  static Future<String> getAddressFromLatLng(Position position) async {
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

  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnakeBarCommon.show(context,
          'Location services are disabled. Please enable the services');

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnakeBarCommon.show(context, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnakeBarCommon.show(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }
}
