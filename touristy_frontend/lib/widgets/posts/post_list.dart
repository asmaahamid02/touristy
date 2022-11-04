import 'package:flutter/material.dart';
import 'package:touristy_frontend/models/user.dart';
import '../../models/post.dart';
import './post_container.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  List<Post> _posts = [
    Post(
      id: '1',
      imageUrl: 'https://picsum.photos/201',
      caption: 'This is a caption',
      location: 'This is a location',
      user: User(
        id: '1',
        name: 'Michael',
        imageUrl: 'https://picsum.photos/202',
      ),
      likes: 100,
      comments: 20,
      shares: 10,
      timeAgo: '1day ago',
    ),
    Post(
      id: '2',
      imageUrl: 'https://picsum.photos/203',
      caption: 'This is a caption',
      location: 'This is a location',
      user: User(
        id: '2',
        name: 'John Doe',
        imageUrl: 'https://picsum.photos/204',
      ),
      likes: 100,
      comments: 20,
      shares: 10,
      timeAgo: '1hr ago',
    ),
    Post(
      id: '3',
      imageUrl: 'https://picsum.photos/205',
      caption: 'This is a caption',
      location: 'This is a location',
      user: User(
        id: '3',
        name: 'Klaus',
        imageUrl: 'https://picsum.photos/206',
      ),
      likes: 100,
      comments: 20,
      shares: 10,
      timeAgo: '53min ago',
    ),
    Post(
      id: '4',
      imageUrl: 'https://picsum.photos/250?image=9',
      caption: 'This is a caption',
      location: 'This is a location',
      user: User(
        id: '4',
        name: 'Alex Doe',
        imageUrl: 'https://picsum.photos/208',
      ),
      likes: 100,
      comments: 20,
      shares: 10,
      timeAgo: '2hr ago',
    ),
    Post(
      id: '5',
      imageUrl: 'https://picsum.photos/209',
      caption: 'This is a caption',
      location: 'This is a location',
      user: User(
        id: '5',
        name: 'Frank',
        imageUrl: 'https://picsum.photos/210',
      ),
      likes: 100,
      comments: 20,
      shares: 10,
      timeAgo: '1day ago',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return PostContainer(
        post: _posts[index],
      );
    }, childCount: _posts.length));
  }
}
