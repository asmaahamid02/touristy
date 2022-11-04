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
                  const SizedBox(height: 6.0),
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
          imageUrl: post.user.imageUrl,
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
                  post.user.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              post.location != ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: [
                        Icon(Icons.location_on,
                            color: Colors.red[600], size: 12.0),
                        const SizedBox(width: 5.0),
                        Text(
                          post.location,
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

//post stats widget
class _PostStats extends StatelessWidget {
  final Post post;

  const _PostStats({required this.post});

  @override
  Widget build(BuildContext context) {
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
                      Icons.favorite_border_outlined,
                      size: 20.0,
                      color: Colors.grey[600],
                    ),
                    label: 'Like',
                    onTap: () {}),
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
  final VoidCallback onTap;

  const _PostButton(
      {required this.icon, required this.label, required this.onTap});

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
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
