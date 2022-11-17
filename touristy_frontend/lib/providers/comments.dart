import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class Comments with ChangeNotifier {
  final List<Comment> _comments = [];

  int _currentPage = 1;

  String? authToken;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;

      notifyListeners();
    }
  }

  //get comments
  List<Comment> get comments {
    return [..._comments];
  }

  void resetComments() {
    _currentPage = 1;
    _comments.clear();
  }

  //get comments by post
  Future<List<Comment>> fetchAndSetCommentsByPost(int postId) async {
    try {
      final comments = await CommentService.getCommentsByPost(
          authToken as String, postId, _currentPage);

      _currentPage++;
      //add comments that are not already in the list
      for (var comment in comments) {
        if (!_comments.any((element) => element.id == comment.id)) {
          _comments.add(comment);
        }
      }
      notifyListeners();
      return comments;
    } catch (error) {
      rethrow;
    }
  }
}
