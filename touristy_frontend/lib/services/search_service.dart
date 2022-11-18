import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utilities/constants.dart';
import '../models/models.dart';

class SearchService {
  static Future<List<dynamic>> getSearchResults(
      String token, String searchValue) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/common/search/$searchValue'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        print(responseData);
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  //search users
  static Future<List<User>> searchUsers(String token, String query) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/common/search/users/$query'),
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
}
