import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile();
  DateTime? _lastUpdated;
  int? lastUpdatedUserId;

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
    if (lastUpdatedUserId == userId &&
        _lastUpdated != null &&
        DateTime.now().difference(_lastUpdated!).inMinutes < 1) {
      return;
    }
    try {
      final userProfileResults =
          await UsersService.getUserProfile(authToken!, userId);
      _userProfile = userProfileResults;
      _lastUpdated = DateTime.now();
      lastUpdatedUserId = userId;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
