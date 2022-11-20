import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile();

  String? authToken;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;

      notifyListeners();
    }
  }

  UserProfile get userProfile => _userProfile;

  Future<void> setUserProfile(int userId) async {
    if (_userProfile.id == userId) {
      return;
    }
    try {
      final userProfileResults =
          await UsersService.getUserProfile(authToken!, userId);
      _userProfile = userProfileResults;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
