class User {
  final int id;
  final String firstName;
  final String lastName;
  String? nationality;
  String? countryCode;
  String? email;
  String? dateOfBirth;
  String? gender;
  String? profilePictureUrl;
  String? coverPictureUrl;
  String? bio;
  bool? isFollowedByUser;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.nationality,
    this.countryCode,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.profilePictureUrl,
    this.coverPictureUrl,
    this.bio,
    this.isFollowedByUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      nationality: json['nationality'] != null
          ? json['nationality']['nationality']
          : null,
      countryCode: json['nationality'] != null
          ? json['nationality']['country_code'] as String
          : null,
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      profilePictureUrl: json['profile_picture'],
      coverPictureUrl: json['cover_picture'],
      bio: json['bio'],
      isFollowedByUser: json['isFollowedByUser'] ?? false,
    );
  }
}
