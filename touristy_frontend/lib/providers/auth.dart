import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';
import '../exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  int? _userId;
  Timer? _authTimer;

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

  int? get userId {
    return _userId;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(loginUrl),
          body: json.encode({'email': email, 'password': password}),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          });
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      }

      _token = responseData['data']['token'];

      _userId = responseData['data']['user_id'];
      _expiryDate = DateTime.now().add(
        Duration(
          minutes: int.parse(responseData['data']['expires_in']),
        ),
      );
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

//sign up
  Future<void> signup(Map<String, dynamic> data) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(registerUrl));

      request.headers.addAll({
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      });

      request.fields['first_name'] = data['first_name'];
      request.fields['last_name'] = data['last_name'];
      request.fields['email'] = data['email'];
      request.fields['password'] = data['password'];
      request.fields['gender'] = data['gender'];
      request.fields['date_of_birth'] =
          DateFormat.yMMMd().parse(data['date_of_birth']).toString();

      request.fields['nationality'] = data['nationality'];
      request.fields['country_code'] = data['country_code'];
      request.fields['role'] = 'user';

      if (data['latitude'] != null &&
          data['longitude'] != null &&
          data['address'] != null &&
          data['latitude'] != 0.0 &&
          data['longitude'] != 0.0 &&
          data['address'] != '') {
        request.fields['latitude'] = data['latitude'].toString();
        request.fields['longitude'] = data['longitude'].toString();
        request.fields['address'] = data['address'].toString();
      }

      if (data['profile_picture'] != null) {
        request.files.add(http.MultipartFile(
            'profile_picture',
            data['profile_picture'].readAsBytes().asStream(),
            data['profile_picture'].lengthSync(),
            filename: data['profile_picture'].path.split('/').last));
      }

      final response = await request.send();

      final responseData = await response.stream.bytesToString();

      final decodedResponse = json.decode(responseData) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(decodedResponse));
      }

      _token = decodedResponse['data']['token'];

      _userId = decodedResponse['data']['user_id'];
      _expiryDate = DateTime.now().add(
        Duration(
          minutes: int.parse(decodedResponse['data']['expires_in']),
        ),
      );
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as int;
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
