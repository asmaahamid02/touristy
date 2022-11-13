import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/utilities.dart';
import '../../exceptions/http_exception.dart';
import '../../providers/posts.dart';
import '../../widgets/widgets.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false)
        .fetchAndSetFollowingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: const CustomScrollView(
        slivers: [
          _PostsList(),
        ],
      ),
    );
  }
}

class _PostsList extends StatefulWidget {
  const _PostsList();

  @override
  State<_PostsList> createState() => __PostsListState();
}

class __PostsListState extends State<_PostsList> {
  var isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      _isLoading = true;

      try {
        await Provider.of<Posts>(context).fetchAndSetFollowingPosts();
      } on HttpException catch (error) {
        SnakeBar.show(context, error.toString());
      } catch (error) {
        SnakeBar.show(context, 'Could not fetch posts, try again later.');
      }
      setState(() {
        _isLoading = false;
      });

      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context);
    final posts = postsData.followingPosts;

    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No posts yet.'),
        ),
      );
    } else {
      return _isLoading
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = posts[index];
                  return PostContainer(post: post);
                },
                childCount: posts.length,
              ),
            );
    }
  }
}
