import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

import '../models/post.dart';

class PostsService {
  Future<List<Post>> getPosts(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
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
    final response = await http.get(Uri.parse('$baseUrl/posts/like/$postId'),
        headers: getHeaders(token));

    //check if response is has error, throw exception
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  //add post
  Future<Post> addPost(String token, String? content, List<File>? media) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

      request.headers.addAll(getHeaders(token));

      if (content != null && content != '') {
        request.fields['content'] = content;
      }

      request.fields['publicity'] = 'public';

      if (media != null && media.isNotEmpty) {
        for (var i = 0; i < media.length; i++) {
          request.files.add(http.MultipartFile('media[]',
              media[i].readAsBytes().asStream(), media[i].lengthSync(),
              filename: media[i].path.split('/').last));
        }
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();

      final responseString = String.fromCharCodes(responseData);
      final decodedResponse =
          json.decode(responseString) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(json.decode(responseString)));
      }

      return Post.fromJson(decodedResponse['data']);
    } catch (error) {
      rethrow;
    }
  }
}
