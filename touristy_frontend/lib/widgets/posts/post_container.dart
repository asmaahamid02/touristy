import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/providers/users.dart';

import '../../providers/posts.dart';
import '../profile_avatar.dart';
import '../../models/post.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({super.key, required this.post});
  final Post post;

//get image from url with token
  Widget _getImage(String? url, String? token) {
    if (url != null) {
      return Image.network(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<Posts>(context, listen: false).authToken as String;
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
                  const SizedBox(height: 6.0),
                  post.content != null
                      ? Text(
                          post.content!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 6.0),
                  post.mediaUrls != null
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          height: 6.0,
                        ),
                ]),
          ),
          post.mediaUrls != null && post.mediaUrls!.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _getImage(post.mediaUrls![0]['media_path'], token),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _PostStats(post: post),
          )
        ],
      ),
    );
  }
}

//post header widget
class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl: post.user.profilePictureUrl as String,
          radius: 20,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${post.user.firstName} ${post.user.lastName}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              post.location != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: [
                        Icon(Icons.location_on,
                            color: Colors.red[600], size: 12.0),
                        const SizedBox(width: 5.0),
                        Text(
                          post.location as String,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ]),
                    )
                  : const SizedBox.shrink(),
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
            Consumer<Users>(
              builder: (_, value, __) => TextButton(
                  onPressed: () {},
                  child: Text(
                    value.isFollowed(post.user.id) ? 'Following' : 'Follow',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
            ),
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

//post stats widget
class _PostStats extends StatelessWidget {
  final Post post;

  const _PostStats({required this.post});

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context, listen: false);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${post.likes} Likes',
                style: Theme.of(context).textTheme.bodySmall),
            Text('${post.comments} Comments',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                _PostButton(
                    icon: Icon(
                      post.isLiked! ? Icons.favorite : Icons.favorite_border,
                      size: 20.0,
                      color: post.isLiked!
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                    ),
                    label: 'Like',
                    isActive: post.isLiked!,
                    onTap: () {
                      posts.toggleLikeStatus(post.id);
                    }),
                _PostButton(
                    icon: Icon(Icons.message_outlined,
                        size: 20.0, color: Colors.grey[600]),
                    label: 'Comment',
                    onTap: () {}),
              ],
            )),
            _PostButton(
                icon: Icon(Icons.near_me_outlined,
                    size: 20.0, color: Colors.grey[600]),
                label: 'Share',
                onTap: () {}),
          ],
        ),
      ],
    );
  }
}

//post button widget
class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  bool? isActive = false;
  final VoidCallback onTap;

  _PostButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isActive});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4.0),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isActive != null && isActive!
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
