import 'package:timeago/timeago.dart' as timeago;

import './user.dart';
import '../constants.dart';

class Post {
  final int id;
  final User user;
  List<Map<String, dynamic>>? mediaUrls;
  String? content;
  final int? likes;
  final int comments;
  final String timeAgo;
  String? location;

  Post({
    required this.id,
    this.mediaUrls,
    this.content,
    required this.likes,
    required this.comments,
    required this.user,
    required this.timeAgo,
    this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      mediaUrls: json['media'].length > 0
          ? (json['media'] as List<dynamic>).map((e) {
              return {
                'media_path': '$fileBaseUrl${e['media_path']}',
                'media_type': e['media_type'],
              };
            }).toList()
          : null,
      content: json['content'] as String,
      likes: json['likes_count'] as int,
      comments: json['comments_count'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      timeAgo: timeago.format(DateTime.parse(json['created_at']), locale: 'en'),
      location: json['location'] != null
          ? '${json['location']['city']}, ${json['location']['country']}'
          : null,
    );
  }
}
