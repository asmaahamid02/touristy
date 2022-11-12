import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class TravelersUsers with ChangeNotifier {
  final List<TravelerUser> _travelersUsers = [];

  String? authToken;

  void update(Auth auth) {
    if (auth.token != null) {
      authToken = auth.token;
      notifyListeners();
    }
  }

  List<TravelerUser> get travelersUsers => _travelersUsers;

  Future<void> fetchTravelersUsers() async {
    try {
      final List<TravelerUser> travelersUsers =
          await TravelersService().getTravelersUsers(authToken!);
      _travelersUsers.clear();
      _travelersUsers.addAll(travelersUsers);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
