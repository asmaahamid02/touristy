import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import './utilities.dart';

class LocationHandler {
  static const GOOGLE_API_KEY = 'AIzaSyCTh9nt09BXB492g4fj3PfAdVwhlIdJcAM';
  static Future<Position> getCurrentPosition(BuildContext context) async {
    try {
      final hasPermission = await handleLocationPermission(context);
      if (!hasPermission) return Future.error('Location permission denied');
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } catch (error) {
      SnakeBarCommon.show(context, error.toString());
      return Future.error(error);
    }
  }

  static Future<String> getAddressFromLatLng(
      BuildContext context, double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
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
      SnakeBarCommon.show(context,
          'Could not get address from location. Please try again later.');
      return '';
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

  static Future<dynamic> getLocationResults(
      String input, String sessionToken) async {
    String kPLACESAPIKEY = LocationHandler.GOOGLE_API_KEY;
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final res = json.decode(response.body)['predictions'];
      return res;
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
