import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class Trips with ChangeNotifier {
  List<Trip> _trips = [];
  String? authToken;
  DateTime? _lastUpdated;
  int? lastUpdatedUserId;

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
    if (lastUpdatedUserId == userId &&
        _lastUpdated != null &&
        DateTime.now().difference(_lastUpdated!).inMinutes < 1) {
      return;
    }
    try {
      final List<Trip> trips = await TripService.getTrips(authToken!, userId);
      _trips = trips;
      _lastUpdated = DateTime.now();
      lastUpdatedUserId = userId;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //add trip
  Future<void> addTrip(Trip trip) async {
    try {
      final Trip newTrip = await TripService.addTrip(authToken!, trip);
      _trips.insert(0, newTrip);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //delete trip
  Future<void> deleteTrip(int tripId) async {
    final deletedTripIndex = _trips.indexWhere((trip) => trip.id == tripId);

    if (deletedTripIndex < 0) throw Exception('Trip not found');

    var deletedTrip = _trips[deletedTripIndex];
    _trips.removeAt(deletedTripIndex);
    notifyListeners();

    try {
      await TripService.deleteTrip(authToken!, tripId);
      _trips.removeWhere((trip) => trip.id == tripId);
    } catch (error) {
      _trips.insert(deletedTripIndex, deletedTrip);
      notifyListeners();
      rethrow;
    }
  }
}
