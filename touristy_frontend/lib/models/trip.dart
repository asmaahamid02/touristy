class Trip {
  final int id;
  final String? title;
  final String? description;
  final String destination;
  final DateTime arrivalDate;
  final DateTime? departureDate;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.arrivalDate,
    required this.departureDate,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      destination:
          json['location'] != null ? json['location']['address'] : null,
      arrivalDate: DateTime.parse(json['arrival_date']),
      departureDate: json['departure_date'] != null
          ? DateTime.parse(json['departure_date'])
          : null,
    );
  }
}
