import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';

import '../utilities/constants.dart';
import '../models/user.dart';

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
  Future<bool> followUser(String token, int userId) async {
    var response = await http.post(Uri.parse('$baseUrl/users/follow/$userId'),
        headers: getHeaders(token));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
