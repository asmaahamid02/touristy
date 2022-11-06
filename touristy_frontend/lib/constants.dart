//---- STRINGS ------

import 'dart:math';

const String baseUrl = 'http://10.0.2.2:8000/api/v0.1';
const String fileBaseUrl = 'http://10.0.2.2:8000/api/v0.1/common/file/';
const String loginUrl = '$baseUrl/auth/login';
const String registerUrl = '$baseUrl/auth/register';

//---- ERRORS ------
const String serverError = 'Server Error';
const String noInternetError = 'No Internet Connection';
const String unauthorizedError = 'Unauthorized';
const String somethingWentWrongError = 'Something went wrong';

//----METHODS-----
//randomly select number of distinct items from a list
List<T> randomItems<T>(List<T> items, int count) {
  var random = Random();
  var result = <T>[];
  for (var i = 0; i < count; i++) {
    result.add(items[random.nextInt(items.length)]);
  }
  return result;
}

//get response error
String getResponseError(dynamic responseData) {
  String error = '';
  if (responseData['error'] != null) {
    final errors = responseData['error'];
    error = errors[errors.keys.first][0];
  } else {
    error = responseData['message'];
  }
  return error;
}
