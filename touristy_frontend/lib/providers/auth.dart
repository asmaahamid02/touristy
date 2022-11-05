import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  int? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> login(String email, String password) async {
    String error = '';
    try {
      final response = await http.post(Uri.parse(loginUrl),
          body: json.encode({'email': email, 'password': password}),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          });
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        if (responseData['error'] != null) {
          final errors = responseData['error'];
          error = errors[errors.keys.first][0];
        } else {
          error = responseData['message'];
        }
        if (error.isNotEmpty) {
          throw HttpException(error);
        }
      }

      _token = responseData['data']['token'];

      _userId = responseData['data']['user_id'];
      _expiryDate = DateTime.now().add(
        Duration(
          minutes: int.parse(responseData['data']['expires_in']),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
