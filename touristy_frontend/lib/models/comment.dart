import 'package:timeago/timeago.dart' as timeago;

class Comment {
  int? id;
  String? content;
  String? userName;
  String? profilePicture;
  String? createdAt;
  bool? isLiked;
  int? likesCount;

  Comment({
    this.id,
    this.content,
    this.userName,
    this.profilePicture,
    this.createdAt,
    this.isLiked,
    this.likesCount,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"],
        userName: '${json["user"]["first_name"]} ${json["user"]["last_name"]}',
        profilePicture: json["user"]["profile_picture"],
        createdAt:
            timeago.format(DateTime.parse(json['created_at']), locale: 'en'),
        isLiked: json["isLiked"],
        likesCount: json["likes"],
      );
}
