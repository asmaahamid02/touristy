//---- STRINGS ------

import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//needed ip address of the WIFI network
//it is preferrable to connect the desktop to the same network as the mobile device
final String baseUrl =
    '${dotenv.env['APP_HOST']!}:${dotenv.env['APP_PORT']!}/api/v0.1';
final String loginUrl = '$baseUrl/auth/login';
final String registerUrl = '$baseUrl/auth/register';

//---- ERRORS ------
const String serverError = 'Server Error';
const String noInternetError = 'No Internet Connection';
const String unauthorizedError = 'Unauthorized';
const String somethingWentWrongError = 'Something went wrong';

//----METHODS-----
//get response error
String getResponseError(dynamic responseData) {
  String error = '';
  if (responseData['errors'] != null) {
    final errors = responseData['errors'];
    error = errors[errors.keys.first][0];
  } else {
    error = responseData['message'];
  }
  return error;
}

getHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
    HttpHeaders.connectionHeader: 'keep-alive'
  };
}

//----UTILITIES-----
enum Gender { female, male, other }
