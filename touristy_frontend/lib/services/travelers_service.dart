import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:touristy_frontend/exceptions/http_exception.dart';

import '../models/models.dart';
import '../utilities/utilities.dart';

class TravelersService {
  Future<List<TravelerUser>> getTravelersUsers(String token,
      {int limit = 20}) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/users/suggested/$limit'),
          headers: getHeaders(token));
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> travelersList = responseData['data'];
          final users = travelersList
              .map((traveler) => TravelerUser.fromJson(traveler))
              .toList();
          return users;
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}
