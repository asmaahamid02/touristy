import 'package:timeago/timeago.dart' as timeago;

import './user.dart';

class Post {
  final int id;
  User? user;
  List<Map<String, dynamic>>? mediaUrls;
  String? content;
  int? likes;
  int? comments;
  String? timeAgo;
  String? location;
  bool? isLiked;

  Post({
    required this.id,
    this.mediaUrls,
    this.content,
    this.likes,
    this.comments,
    this.user,
    this.timeAgo,
    this.location,
    this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    Post post = Post(
      id: json['id'] as int,
      mediaUrls: json['media'].length > 0
          ? (json['media'] as List<dynamic>).map((e) {
              return {
                'path': e['path'],
                'type': e['type'],
              };
            }).toList()
          : null,
      content: json['content'],
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      timeAgo: timeago.format(DateTime.parse(json['created_at']), locale: 'en'),
      location: json['location'] != null
          ? '${json['location']['city']}, ${json['location']['country']}'
          : null,
      isLiked: json['isLikedByUser'],
    );
    return post;
  }
}
