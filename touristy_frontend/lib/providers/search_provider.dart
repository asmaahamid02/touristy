import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class SearchProvider with ChangeNotifier {
  List<User> _users = [];
  List<Post> _posts = [];
  List<Trip> _trips = [];

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
    if (query.isEmpty) {
      _users.clear();
      notifyListeners();
      return;
    }
    try {
      final List<User> users =
          await SearchService.searchUsers(authToken!, query);
      _users = users;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //search trips
  Future<void> searchTrips(String query) async {
    if (query.isEmpty) {
      _trips.clear();
      notifyListeners();
      return;
    }
    try {
      final List<Trip> trips =
          await SearchService.searchTrips(authToken!, query);
      _trips = trips;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //search posts
  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      _posts.clear();
      notifyListeners();
      return;
    }
    try {
      final List<Post> posts =
          await SearchService.searchPosts(authToken!, query);
      _posts = posts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
