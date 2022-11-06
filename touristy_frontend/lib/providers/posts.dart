import 'package:flutter/material.dart';
import 'package:touristy_frontend/services/posts_service.dart';
import './auth.dart';
import '../models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  String? authToken;
  int? userId;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;
      userId = auth.userId;
      notifyListeners();
    }
  }

  List<Post> get posts {
    return [..._posts];
  }

  //get posts
  Future<void> fetchAndSetPosts() async {
    final posts = await PostsService().getPosts(authToken as String);

    _posts = posts;

    notifyListeners();
  }

  Future<void> toggleLikeStatus(int postId) async {
    final int postIndex = _posts.indexWhere((post) => post.id == postId);

    if (postIndex >= 0) {
      _posts[postIndex].isLiked = !_posts[postIndex].isLiked!;
      _posts[postIndex].likes = _posts[postIndex].isLiked!
          ? _posts[postIndex].likes! + 1
          : _posts[postIndex].likes! - 1;
      notifyListeners();

      try {
        await PostsService().toggleLikePost(authToken as String, postId);
      } catch (error) {
        _posts[postIndex].isLiked = !_posts[postIndex].isLiked!;
        _posts[postIndex].likes = _posts[postIndex].isLiked!
            ? _posts[postIndex].likes! + 1
            : _posts[postIndex].likes! - 1;
        notifyListeners();
      }
    }
  }
}
