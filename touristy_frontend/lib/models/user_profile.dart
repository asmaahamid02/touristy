class UserProfile {
  int? id;
  String? name;
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
  String? joinedAt;

  UserProfile({
    this.id,
    this.name,
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
    this.joinedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: '${json['first_name']} ${json['last_name']} ',
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
      joinedAt: json['joinedAt'],
    );
  }
}
