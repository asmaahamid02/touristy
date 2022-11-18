import 'dart:math';

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

//find user by id
  User findUserById(int id) {
    return _users.firstWhere((user) => user.id == id);
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
  Future<String> followUser(int userId) async {
    final int userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex >= 0) {
      _users[userIndex].isFollowedByUser = !_users[userIndex].isFollowedByUser!;
      notifyListeners();

      try {
        final String response =
            await UsersService().followUser(authToken as String, userId);

        return response;
      } catch (error) {
        _users[userIndex].isFollowedByUser =
            !_users[userIndex].isFollowedByUser!;
        notifyListeners();
      }
    }
    return 'User not found';
  }

  //get random users from _users
  List<User> getRandomUsers(int limit) {
    final List<User> randomUsers = [];
    final List<User> users = _users
        .where((user) =>
            user.id != currentUserId && user.isFollowedByUser == false)
        .toList();

    if (users.isNotEmpty) {
      if (limit > users.length) {
        limit = users.length;
      }
      for (int i = 0; i < limit; i++) {
        //get random user from users that is not already in randomUsers
        final randomUser = users[Random().nextInt(users.length)];
        if (!randomUsers.contains(randomUser)) {
          randomUsers.add(randomUser);
        } else {
          i--;
        }
      }
    }

    return randomUsers;
  }
}
