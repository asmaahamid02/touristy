import 'dart:io';

import 'package:flutter/material.dart';
import 'package:touristy_frontend/services/posts_service.dart';
import 'package:touristy_frontend/services/services.dart';
import './auth.dart';
import '../models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _followingPosts = [];

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

  List<Post> get followingPosts {
    return [..._followingPosts];
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

  //delete post
  Future<void> deletePost(int postId) async {
    final int postIndex = _posts.indexWhere((post) => post.id == postId);

    if (postIndex >= 0) {
      final post = _posts[postIndex];
      _posts.removeAt(postIndex);
      notifyListeners();

      try {
        await PostsService().deletePost(authToken as String, postId);
      } catch (error) {
        _posts.insert(postIndex, post);
        notifyListeners();
      }
    }
  }

  //edit post
  Future<void> editPost(int postId, String? content, List<File>? media) async {
    final int postIndex = _posts.indexWhere((post) => post.id == postId);

    if (postIndex >= 0) {
      try {
        final updatedPost = await PostsService()
            .editPost(authToken as String, postId, content, media);
        _posts[postIndex] = updatedPost;
        notifyListeners();
      } catch (error) {
        print(error);
        rethrow;
      }
    }
  }

  //fetch following posts
  Future<void> fetchAndSetFollowingPosts() async {
    final posts = await PostsService().getFollowingPosts(authToken as String);

    _followingPosts = posts;

    notifyListeners();
  }
}
