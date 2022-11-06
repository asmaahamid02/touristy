import 'package:flutter/cupertino.dart';
import './auth.dart';
import '../models/user.dart';
import '../services/users_service.dart';

class Users with ChangeNotifier {
  List<User> _users = [];

  String? authToken;
  int? currentUserId;

  void update(Auth auth) {
    if (auth.token != null) {
      authToken = auth.token;
      currentUserId = auth.userId;
      notifyListeners();
    }
  }

  List<User> get users {
    return [..._users];
  }

  //get users
  Future<void> fetchAndSetUsers() async {
    final users = await UsersService().getUsers(authToken as String);

    _users = users;

    notifyListeners();
  }

  bool isFollowed(int userId) {
    return _users.any((user) => user.id == userId && user.isFollowing == true);
  }

  //follow user
  Future<void> followUser(int userId) async {
    final int userIndex = _users.indexWhere((user) => user.id == userId);

    if (userIndex >= 0) {
      _users[userIndex].isFollowing = !_users[userIndex].isFollowing!;
      notifyListeners();

      try {
        await UsersService().followUser(authToken as String, userId);
      } catch (error) {
        _users[userIndex].isFollowing = !_users[userIndex].isFollowing!;
        notifyListeners();
      }
    }
  }
}
