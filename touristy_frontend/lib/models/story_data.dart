class StoryData {
  final int id;
  String? name;
  String? url;
  String? countryCode;
  bool? isOnline;

  StoryData({
    required this.id,
    this.name,
    this.url,
    this.countryCode,
    this.isOnline,
  });
}
