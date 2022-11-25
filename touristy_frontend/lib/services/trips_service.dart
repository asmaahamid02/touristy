import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:touristy_frontend/exceptions/http_exception.dart';
import '../utilities/utilities.dart';
import '../models/models.dart';

class TripsService {
  static Future<List<Trip>> getTripsByUser(String token, int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/user/$userId'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> tripsList = responseData['data'];
          return tripsList.map((trip) => Trip.fromJson(trip)).toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  //add trip
  static Future<Trip> addTrip(String token, Trip trip) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/trips'),
          headers: getHeaders(token),
          body: json.encode({
            'title': trip.title,
            'description': trip.description,
            'longitude': trip.longitude,
            'latitude': trip.latitude,
            'address': trip.destination,
            'arrival_date': trip.arrivalDate?.toIso8601String(),
            'departure_date': trip.departureDate?.toIso8601String(),
          }));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 201) {
        throw HttpException(getResponseError(responseData));
      } else {
        return Trip.fromJson(responseData['data']);
      }
    } catch (error) {
      rethrow;
    }
  }

  //delete trip
  static Future<void> deleteTrip(String token, int tripId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/trips/$tripId'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      }
    } catch (error) {
      rethrow;
    }
  }

  //get trips locations
  static Future<List<GroupedLocations>> getTripsLocations(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/locations'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> tripsList = responseData['data'];
          return tripsList
              .map((trip) => GroupedLocations.fromJson(trip))
              .toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  //get trips by ids
  static Future<List<Trip>> getTripsByIds(String token, List<int> ids) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/trips/ids'),
          headers: getHeaders(token),
          body: json.encode({
            'ids': ids,
          }));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      print('getTripsByIds: $responseData');
      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> tripsList = responseData['data'];
          return tripsList.map((trip) => Trip.fromJson(trip)).toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}
