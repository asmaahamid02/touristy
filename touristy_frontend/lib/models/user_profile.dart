import 'package:intl/intl.dart';

class UserProfile {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? nationality;
  String? countryCode;
  String? gender;
  String? address;
  int? followers;
  int? followings;
  String? profilePictureUrl;
  String? coverPictureUrl;
  String? bio;
  bool? isFollowingUser;
  bool? isFollowedByUser;
  bool? isBlockedByUser;
  bool? isBlockingUser;
  String? birthDate;
  String? joinedAt;

  UserProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.nationality,
    this.countryCode,
    this.gender,
    this.address,
    this.followers,
    this.followings,
    this.profilePictureUrl,
    this.coverPictureUrl,
    this.bio,
    this.isFollowingUser,
    this.isFollowedByUser,
    this.isBlockedByUser,
    this.isBlockingUser,
    this.birthDate,
    this.joinedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      nationality: json['nationality'] != null
          ? json['nationality']['nationality']
          : null,
      countryCode: json['nationality'] != null
          ? json['nationality']['country_code']
          : null,
      gender: json['gender'],
      address: json['location'] != null ? json['location']['address'] : null,
      followers: json['followers'] ?? 0,
      followings: json['followings'] ?? 0,
      profilePictureUrl: json['profile_picture'],
      coverPictureUrl: json['cover_picture'],
      bio: json['bio'],
      isFollowingUser: json['isFollowingUser'] ?? false,
      isFollowedByUser: json['isFollowedByUser'] ?? false,
      isBlockedByUser: json['isBlockedByUser'] ?? false,
      isBlockingUser: json['isBlockingUser'] ?? false,
      birthDate:
          DateFormat.yMMMd().format(DateTime.parse(json['date_of_birth'])),
      joinedAt: json['joinedAt'],
    );
  }
}
