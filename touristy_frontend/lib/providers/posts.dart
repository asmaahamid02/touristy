import 'dart:io';

import 'package:flutter/material.dart';
import 'package:touristy_frontend/services/posts_service.dart';
import './auth.dart';
import '../models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  String? authToken;
  int? currentUserId;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;
      currentUserId = auth.userId;
      notifyListeners();
    }
  }

  List<Post> get posts {
    return [..._posts];
  }

//find post by id
  Post? findById(int id) {
    return _posts.firstWhere((post) => post.id == id);
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

//add post
  Future<void> addPost(String? content, List<File>? media) async {
    try {
      final post =
          await PostsService().addPost(authToken as String, content, media);
      _posts.add(post);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
