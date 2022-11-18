class Trip {
  final int? id;
  final int? userId;
  final String? title;
  final String? description;
  final String destination;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  double? latitude;
  double? longitude;

  Trip({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.destination,
    required this.arrivalDate,
    required this.departureDate,
    this.latitude,
    this.longitude,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      destination:
          json['location'] != null ? json['location']['address'] : null,
      arrivalDate: json['arrival_date'] != null
          ? DateTime.parse(json['arrival_date'])
          : null,
      departureDate: json['departure_date'] != null
          ? DateTime.parse(json['departure_date'])
          : null,
    );
  }
}
