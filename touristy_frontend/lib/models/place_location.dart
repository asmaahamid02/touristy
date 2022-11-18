class PlaceLocation {
  final double? latitude;
  final double? longitude;
  final String? address;

  const PlaceLocation({this.latitude, this.longitude, this.address});

  PlaceLocation.fromMap(Map<String, dynamic> map)
      : latitude = map['latitude'],
        longitude = map['longitude'],
        address = map['address'];
}
