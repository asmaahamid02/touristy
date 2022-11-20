import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';

import '../utilities/utilities.dart';
import '../models/models.dart';

class UsersService {
  Future<List<User>> getUsers(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> usersList = responseData['data'];
          return usersList.map((user) => User.fromJson(user)).toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  //follow user
  Future<String> followUser(String token, int userId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/users/follow/$userId'),
          headers: getHeaders(token));

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData['message'];
    } catch (error) {
      rethrow;
    }
  }

  //show user profile
  static Future<UserProfile> getUserProfile(String token, int userId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/users/$userId'),
          headers: getHeaders(token));

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final Map<String, dynamic> userProfile = responseData['data'];
          return UserProfile.fromJson(userProfile);
        } else {
          return UserProfile();
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}
