class GroupedLocations {
  List<int>? ids;
  double? latitude;
  double? longitude;
  String? address;
  int? count;

  GroupedLocations({
    this.ids,
    this.latitude,
    this.longitude,
    this.address,
    this.count,
  });

  factory GroupedLocations.fromJson(Map<String, dynamic> json) {
    return GroupedLocations(
      ids: json['ids'] != null ? List<int>.from(json['ids']) : null,
      latitude:
          json['latitude'] != null ? double.tryParse(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? double.tryParse(json['longitude']) : null,
      address: json['address'],
      count: json['count'],
    );
  }
}
