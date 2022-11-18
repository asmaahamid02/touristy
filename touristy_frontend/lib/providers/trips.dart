import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class Trips with ChangeNotifier {
  List<Trip> _trips = [];
  String? authToken;

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;

      notifyListeners();
    }
  }

  List<Trip> get trips => _trips;

  Future<void> fetchTrips(int userId) async {
    try {
      final List<Trip> trips = await TripService.getTrips(authToken!, userId);
      _trips = trips;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
