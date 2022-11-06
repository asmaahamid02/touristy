import '../constants.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String nationality;
  final String countryCode;
  final String email;
  final String dateOfBirth;
  final String gender;
  String? profilePictureUrl;
  String? coverPictureUrl;
  String? bio;
  String? createdAt;
  String? token;
  bool? isFollowing;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationality,
    required this.countryCode,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    this.profilePictureUrl,
    this.coverPictureUrl,
    this.bio,
    this.createdAt,
    this.token,
    this.isFollowing,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      nationality: json['nationality']['nationality'] as String,
      countryCode: json['nationality']['country_code'] as String,
      email: json['email'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      profilePictureUrl: json['profile_picture'] != null
          ? fileBaseUrl + (json['profile_picture'] as String)
          : '',
      coverPictureUrl: json['cover_picture'] != null
          ? fileBaseUrl + (json['cover_picture'] as String)
          : '',
      bio: json['bio'] != null ? json['bio'] as String : '',
      createdAt: json['created_at'] as String,
      isFollowing:
          json['isFollowing'] == null ? false : json['isFollowing'] ?? false,
    );
  }
}
