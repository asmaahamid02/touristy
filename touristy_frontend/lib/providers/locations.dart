import 'package:flutter/cupertino.dart';
import '../models/models.dart';
import '../services/services.dart';
import './providers.dart';

class Locations with ChangeNotifier {
  List<GroupedLocations>? _tripsLocations = [];

  String? authToken;

  List<GroupedLocations>? get tripsLocations {
    return [..._tripsLocations!];
  }

  void update(
    Auth auth,
  ) {
    if (auth.token != null) {
      authToken = auth.token;
      notifyListeners();
    }
  }

  Future<void> fetchLocations() async {
    try {
      final fetchLocations = await TripsService.getTripsLocations(authToken!);
      _tripsLocations = fetchLocations;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
