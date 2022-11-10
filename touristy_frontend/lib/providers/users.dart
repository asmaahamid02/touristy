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
    //return users without the current user
    return _users.where((user) => user.id != currentUserId).toList();
  }

  User get currentUser {
    return _users.firstWhere((user) => user.id == currentUserId);
  }

  //get users
  Future<void> fetchAndSetUsers() async {
    try {
      final users = await UsersService().getUsers(authToken!);
      _users = users;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  bool isFollowed(int userId) {
    return _users
        .any((user) => user.id == userId && user.isFollowedByUser == true);
  }

  //follow user
  Future<void> followUser(int userId) async {
    final int userIndex = _users.indexWhere((user) => user.id == userId);

    if (userIndex >= 0) {
      _users[userIndex].isFollowedByUser = !_users[userIndex].isFollowedByUser!;
      notifyListeners();

      try {
        await UsersService().followUser(authToken as String, userId);
      } catch (error) {
        _users[userIndex].isFollowedByUser =
            !_users[userIndex].isFollowedByUser!;
        notifyListeners();
      }
    }
  }
}
