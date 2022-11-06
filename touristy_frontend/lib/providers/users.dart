import 'package:flutter/cupertino.dart';
import './auth.dart';
import '../models/user.dart';
import '../services/users_service.dart';

class Users with ChangeNotifier {
  List<User> _users = [];

  String? authToken;

  void update(Auth auth) {
    if (auth.token != null) {
      authToken = auth.token;
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
}
