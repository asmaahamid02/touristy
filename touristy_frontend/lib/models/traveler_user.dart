import '../utilities/utilities.dart';

class TravelerUser {
  final int id;
  final String fullName;
  String? countryCode;
  String? profilePictureUrl;

  TravelerUser(
      {required this.id,
      required this.fullName,
      this.countryCode,
      this.profilePictureUrl});

  factory TravelerUser.fromJson(Map<String, dynamic> json) {
    return TravelerUser(
      id: json['id'] as int,
      fullName: '${json['first_name']} ${json['last_name']}',
      countryCode: json['nationality'] != null
          ? json['nationality']['country_code']
          : null,
      profilePictureUrl: json['profile_picture'] != null
          ? '$fileBaseUrl${json['profile_picture']}'
          : null,
    );
  }
}
