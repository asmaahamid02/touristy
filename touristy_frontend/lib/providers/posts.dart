import 'package:flutter/material.dart';
import 'package:touristy_frontend/services/posts_service.dart';
import './auth.dart';
import '../models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  String? authToken;

  void update(Auth auth) {
    if (auth.token != null) {
      authToken = auth.token;
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
}
