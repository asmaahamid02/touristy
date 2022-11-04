import 'package:flutter/material.dart';
import '../profile_avatar.dart';
import '../../models/post.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(
                    post: post,
                  ),
                  const SizedBox(height: 4.0),
                  Text(post.caption),
                  const SizedBox(height: 6.0),
                  post.imageUrl != ''
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          height: 6.0,
                        ),
                ]),
          ),
          post.imageUrl != ''
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(post.imageUrl, fit: BoxFit.cover),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl: post.user.imageUrl,
          radius: 20,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                children: [
                  Text(
                    '${post.timeAgo} • ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Icon(Icons.public, size: 12.0, color: Colors.grey[600]),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {},
                child: Text(
                  'Follow',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                )),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
