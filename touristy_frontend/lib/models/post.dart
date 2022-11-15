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
  String? address;
  bool? isLiked;

  Post({
    required this.id,
    this.mediaUrls,
    this.content,
    this.likes,
    this.comments,
    this.user,
    this.timeAgo,
    this.address,
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
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      timeAgo: timeago.format(DateTime.parse(json['created_at']), locale: 'en'),
      address: json['location'] != null ? json['location']['address'] : null,
      isLiked: json['isLikedByUser'] ?? false,
    );
    return post;
  }
}
