import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/theme.dart';

import '../../screens/screens.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({super.key, required this.post});
  final Post post;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  Image? _image;

  bool _loading = true;
  Future<void> _loadImage() async {
    final token = Provider.of<Posts>(context, listen: false).authToken;
    final url = widget.post.mediaUrls?[0]['path'];
    if (url != null) {
      //get image from url
      _image = Image.network(
        url,
        fit: BoxFit.cover,
      );

      //resolve image to get image stream and add listener to it
      _image!.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

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
                    post: widget.post,
                  ),
                  const SizedBox(height: 6.0),
                  widget.post.content != null
                      ? Text(
                          widget.post.content!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 6.0),
                  widget.post.mediaUrls != null
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          height: 6.0,
                        ),
                ]),
          ),
          widget.post.mediaUrls != null && widget.post.mediaUrls!.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _loading
                      ? Center(
                          child: Text(
                          'Loading...',
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ))
                      : _image,
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _PostStats(post: widget.post),
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

  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
            'Do you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).errorColor,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              try {
                Provider.of<Posts>(context, listen: false).deletePost(post.id);
              } catch (e) {
                //show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            },
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<Users>(context, listen: false).currentUserId;
    final StoryData avatar = StoryData(
      url: post.user!.profilePictureUrl,
      isOnline: true,
    );

    return Row(
      children: [
        Avatar(radius: 20.0, imageUrl: post.user!.profilePictureUrl),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${post.user!.firstName} ${post.user!.lastName}',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700),
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
                          style: const TextStyle(
                              color: AppColors.textFaded, fontSize: 12.0),
                        ),
                      ]),
                    )
                  : const SizedBox.shrink(),
              Row(
                children: [
                  Text(
                    '${post.timeAgo} • ',
                    style: const TextStyle(
                        color: AppColors.textFaded, fontSize: 12.0),
                  ),
                  Icon(Icons.public, size: 12.0, color: Colors.grey[600]),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            post.user!.id != currentUserId
                ? Consumer<Users>(
                    builder: (_, value, __) => TextButton(
                      onPressed: () {
                        value.followUser(post.user!.id);
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
                      _showDialog(context);
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
                          ? Theme.of(context).primaryColor
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
                    onTap: () {}),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4.0),
              Text(label,
                  style: TextStyle(
                      color: isActive != null && isActive!
                          ? Theme.of(context).primaryColor
                          : null,
                      fontSize: 12.0)),
            ],
          ),
        ),
      ),
    );
  }
}
