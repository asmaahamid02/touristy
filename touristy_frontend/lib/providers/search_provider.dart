import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class SearchProvider with ChangeNotifier {
  List<User> _users = [];
  final List<Post> _posts = [];
  final List<Trip> _trips = [];

  //get users
  List<User> get users => _users;

  //get posts
  List<Post> get posts => _posts;

  //get trips
  List<Trip> get trips => _trips;

  String? authToken;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;

      notifyListeners();
    }
  }

  //search users
  Future<void> searchUsers(String query) async {
    try {
      final List<User> users =
          await SearchService.searchUsers(authToken!, query);
      _users = users;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
