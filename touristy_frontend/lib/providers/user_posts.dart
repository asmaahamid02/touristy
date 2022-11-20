import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../models/models.dart';
import './providers.dart';
import '../services/services.dart';

class UserPosts with ChangeNotifier {
  List<Post> _posts = [];

  String? authToken;
  DateTime? _lastUpdated;
  int? lastUpdatedUserId;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;

      notifyListeners();
    }
  }

  List<Post> get posts => [..._posts];

  Future<void> fetchAndSetPosts(int userId) async {
    if (lastUpdatedUserId == userId &&
        _lastUpdated != null &&
        DateTime.now().difference(_lastUpdated!).inMinutes < 1) {
      return;
    }
    try {
      final List<Post> loadedPosts =
          await PostsService.getUserPosts(authToken!, userId);
      _posts = loadedPosts;
      _lastUpdated = DateTime.now();
      lastUpdatedUserId = userId;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
