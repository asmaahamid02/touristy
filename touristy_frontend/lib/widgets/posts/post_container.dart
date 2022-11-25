import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/utilities.dart';
import '../../screens/screens.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: post.mediaUrls?[0]['path'],
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
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

enum PostOptions {
  edit,
  delete,
  block,
}

//post header widget
class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<Users>(context, listen: false).currentUserId;
    return Row(
      children: [
        InkWell(
            onTap: () {
              _navigateToProfileScreen(context);
            },
            child:
                Avatar(radius: 20.0, imageUrl: post.user!.profilePictureUrl)),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _navigateToProfileScreen(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${post.user!.firstName} ${post.user!.lastName}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${post.timeAgo} • ',
                    style: const TextStyle(
                        color: AppColors.textFaded, fontSize: 12.0),
                  ),
                  Icon(Icons.public, size: 12.0, color: Colors.grey[600]),
                ],
              ),
              post.address != null && post.address != ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(children: [
                        Icon(Icons.location_on,
                            color: Colors.red[600], size: 12.0),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            post.address as String,
                            style: const TextStyle(
                                color: AppColors.textFaded, fontSize: 12.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        Row(
          children: [
            post.user!.id != currentUserId
                ? Consumer<Users>(
                    builder: (_, value, __) => TextButton(
                      onPressed: () {
                        value
                            .followUser(post.user!.id)
                            .then((response) => ToastCommon.show(response));
                      },
                      child: Text(
                        value.isFollowed(post.user!.id)
                            ? 'Following'
                            : 'Follow',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            PopupMenuButton(
              itemBuilder: (_) => post.user!.id != currentUserId
                  ? [
                      PopupMenuItem(
                        value: PostOptions.block,
                        child: Text(PostOptions.block.name),
                      )
                    ]
                  : [
                      PopupMenuItem(
                        value: PostOptions.edit,
                        child: Text(PostOptions.edit.name),
                      ),
                      PopupMenuItem(
                        value: PostOptions.delete,
                        child: Text(PostOptions.delete.name),
                      ),
                    ],
              icon: const Icon(Icons.more_horiz, color: AppColors.secondary),
              onSelected: (PostOptions value) {
                switch (value) {
                  case PostOptions.edit:
                    {
                      Navigator.of(context).pushNamed(
                        NewPostScreen.routeName,
                        arguments: post.id,
                      );
                    }
                    break;
                  case PostOptions.delete:
                    {
                      AlertDialogCommon.show(
                          context: context,
                          title: 'Are you sure?',
                          content:
                              'Do you want to delete this post? This action cannot be undone.',
                          actionText: 'Yes',
                          action: () {
                            try {
                              Provider.of<Posts>(context, listen: false)
                                  .deletePost(post.id);
                            } catch (e) {
                              //show error message
                              SnakeBarCommon.show(context, e.toString());
                            }
                          });
                    }
                    break;
                  case PostOptions.block:
                    {
                      print('block');
                    }
                    break;
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToProfileScreen(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != ProfileScreen.routeName) {
      Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
        arguments: {
          'userId': post.user!.id,
          'username': '${post.user!.firstName} ${post.user!.lastName}',
        },
      );
    }
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
                style: const TextStyle(
                    color: AppColors.textFaded, fontSize: 12.0)),
            Text('${post.comments} Comments',
                style: const TextStyle(
                    color: AppColors.textFaded, fontSize: 12.0)),
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
                          ? AppColors.secondary
                          : Theme.of(context).iconTheme.color,
                    ),
                    label: 'Like',
                    isActive: post.isLiked!,
                    onTap: () {
                      posts.toggleLikeStatus(post.id);
                    }),
                _PostButton(
                    icon: const Icon(Icons.message_outlined, size: 20.0),
                    label: 'Comment',
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        CommentsScreen.routeName,
                        arguments: post.id,
                      );
                    }),
              ],
            )),
            _PostButton(
                icon: const Icon(Icons.near_me_outlined, size: 20.0),
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
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4.0),
              Text(label,
                  style: TextStyle(
                      color: isActive != null && isActive!
                          ? AppColors.secondary
                          : null,
                      fontSize: 12.0)),
            ],
          ),
        ),
      ),
    );
  }
}
