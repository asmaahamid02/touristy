import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';
import '../utilities/utilities.dart';
import '../models/comment.dart';

class CommentService {
  static Future<List<Comment>> getCommentsByPost(
      String token, int postId, int currenPage) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/comments/post/$postId?page=$currenPage'),
          headers: getHeaders(token));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      //check if response is has error, throw exception
      if (response.statusCode != 200) {
        throw HttpException(getResponseError(responseData));
      } else {
        if (responseData['data'] != null &&
            responseData['data'] != '' &&
            responseData['data'].length > 0) {
          final List<dynamic> commentsList = responseData['data'];
          return commentsList
              .map((comment) => Comment.fromJson(comment))
              .toList();
        } else {
          return [];
        }
      }
    } catch (error) {
      rethrow;
    }
  }
}
