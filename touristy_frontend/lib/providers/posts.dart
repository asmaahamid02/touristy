import 'dart:io';
import 'package:flutter/material.dart';
import '../services/services.dart';
import './providers.dart';
import '../models/models.dart';

class Posts with ChangeNotifier {
  final List<Post> _posts = [];
  final List<Post> _followingPosts = [];

  int _currentPage = 1;
  int _currentPageFollowing = 1;

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

  void resetPosts() {
    _currentPage = 1;
    _posts.clear();
  }

  void resetFollowingPosts() {
    _currentPageFollowing = 1;
    _followingPosts.clear();
  }

//find post by id
  Post? findById(int id) {
    return _posts.firstWhere((post) => post.id == id);
  }

//update comment count
  void updateCommentCount(int postId, int commentCount) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);

    if (postIndex >= 0) {
      _posts[postIndex].comments = commentCount;
      notifyListeners();
    }

    final followingPostIndex =
        _followingPosts.indexWhere((post) => post.id == postId);

    if (followingPostIndex >= 0) {
      _followingPosts[followingPostIndex].comments = commentCount;
      notifyListeners();
    }
  }

  //get posts
  Future<List<Post>> fetchAndSetPosts() async {
    try {
      final posts =
          await PostsService().getPosts(authToken as String, _currentPage);

      _currentPage++;
      //add posts that are not already in the list
      for (var post in posts) {
        if (!_posts.any((element) => element.id == post.id)) {
          _posts.add(post);
        }
      }

      notifyListeners();
      return posts;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleLikeStatus(int postId) async {
    final int postIndex = _posts.indexWhere((post) => post.id == postId);
    final int followingPostIndex =
        _followingPosts.indexWhere((post) => post.id == postId);

    if (postIndex >= 0) {
      _updateLikeStatus(postIndex, _posts);

      if (followingPostIndex >= 0) {
        _updateLikeStatus(followingPostIndex, _followingPosts);
        notifyListeners();
      }

      try {
        await PostsService().toggleLikePost(authToken as String, postId);
      } catch (error) {
        _updateLikeStatus(postIndex, _posts);

        if (followingPostIndex >= 0) {
          _updateLikeStatus(followingPostIndex, _followingPosts);
          notifyListeners();
        }
      }
    }
  }

  void _updateLikeStatus(int postIndex, List<Post> posts) {
    posts[postIndex].isLiked = !posts[postIndex].isLiked!;
    posts[postIndex].likes = posts[postIndex].isLiked!
        ? posts[postIndex].likes! + 1
        : posts[postIndex].likes! - 1;
  }

//add post
  Future<void> addPost(
      String? content, List<File>? media, PlaceLocation coordinates) async {
    try {
      final post = await PostsService()
          .addPost(authToken as String, content, media, coordinates);

      //add post to the top of the list
      _posts.insert(0, post);

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
        rethrow;
      }
    }
  }

  //fetch following posts
  Future<List<Post>> fetchAndSetFollowingPosts() async {
    try {
      final posts = await PostsService()
          .getFollowingPosts(authToken as String, _currentPageFollowing);

      _currentPageFollowing++;
      //add posts that are not already in the list
      for (var post in posts) {
        if (!_followingPosts.any((element) => element.id == post.id)) {
          _followingPosts.add(post);
        }
      }

      notifyListeners();
      return posts;
    } catch (error) {
      rethrow;
    }
  }
}
