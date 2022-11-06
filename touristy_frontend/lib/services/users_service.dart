import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

class UsersService {
  Future<List<User>> getUsers(String token) async {
    var response =
        await http.get(Uri.parse('$baseUrl/users'), headers: getHeaders(token));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['data'] != null &&
          responseData['data'] != '' &&
          responseData['data'].length > 0) {
        final usersList = responseData['data'];

//get following users
        response = await http.get(Uri.parse('$baseUrl/users/followings'),
            headers: getHeaders(token));

        final followingData =
            json.decode(response.body) as Map<String, dynamic>;

        //map data to get user ids
        final followingsList = followingData['data'] != null &&
                followingData['data'] != '' &&
                followingData['data'].length > 0
            ? followingData['data'].map((e) => e['id']).toList()
            : [];

//map user list to get user model
        return usersList.map<User>((user) {
          user['isFollowing'] = followingsList.length <= 0
              ? false
              : followingsList.contains(user['id']) ?? false;
          return User.fromJson(user);
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load users');
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
