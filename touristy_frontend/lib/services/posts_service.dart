import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

import '../models/post.dart';

class PostsService {
  Future<List<Post>> getPosts(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'), headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null) {
          final List<dynamic> postsList = responseData['data'];
          return postsList.map((post) => Post.fromJson(post)).toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  //toggle like post
  Future<bool> toggleLikePost(String token, int postId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/posts/like/$postId'), headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        String message = responseData['message'];
        //check if message contains liked unliked
        if (message.contains('liked')) {
          return true;
        }
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }
}
