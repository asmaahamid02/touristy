import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

class UsersService {
  Future<List<User>> getUsers(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/users'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String jsonDataString = response.body.toString().replaceAll("\n", "");
      final Map<String, dynamic> users = json.decode(jsonDataString);
      final List<dynamic> usersList = users['data'];
      return usersList.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
