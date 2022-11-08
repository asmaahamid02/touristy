import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/posts.dart';
import './post_container.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  var isInit = true;
  var _isLoading = false;

  void _showSnakeBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Posts>(context).fetchAndSetPosts();
      } on HttpException catch (error) {
        _showSnakeBar(error.toString());
      } catch (error) {
        _showSnakeBar('Could not fetch posts. Please try again later.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context);
    final posts = postsData.posts;
    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No posts yet.'),
        ),
      );
    } else {
      return _isLoading
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostContainer(
                    post: posts[index],
                  );
                },
                childCount: posts.length,
              ),
            );
    }
  }
}
