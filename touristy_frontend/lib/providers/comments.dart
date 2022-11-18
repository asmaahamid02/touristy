import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class Comments with ChangeNotifier {
  List<Comment> _comments = [];

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

  //reset comments
  void resetComments() {
    _comments.clear();
  }

  //get comments by post
  Future<List<Comment>> fetchAndSetCommentsByPost(int postId) async {
    try {
      final comments =
          await CommentService.getCommentsByPost(authToken as String, postId);

      if (comments.isNotEmpty) {
        _comments = comments;
      } else {
        resetComments();
      }
      notifyListeners();
      return comments;
    } catch (error) {
      resetComments();
      rethrow;
    }
  }

  //add comment
  Future<void> addComment(int postId, String comment) async {
    try {
      final newComment =
          await CommentService.addComment(authToken as String, postId, comment);
      _comments.add(newComment);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleLikeStatus(int commentId) async {
    final int commentIndex =
        _comments.indexWhere((comment) => comment.id == commentId);

    if (commentIndex >= 0) {
      _comments[commentIndex].isLiked = !_comments[commentIndex].isLiked!;
      _comments[commentIndex].likesCount = _comments[commentIndex].isLiked!
          ? _comments[commentIndex].likesCount! + 1
          : _comments[commentIndex].likesCount! - 1;
      notifyListeners();

      try {
        await CommentService.toggleLikeComment(authToken as String, commentId);
      } catch (error) {
        _comments[commentIndex].isLiked = !_comments[commentIndex].isLiked!;
        _comments[commentIndex].likesCount = _comments[commentIndex].isLiked!
            ? _comments[commentIndex].likesCount! + 1
            : _comments[commentIndex].likesCount! - 1;
        notifyListeners();
      }
    }
  }
}
