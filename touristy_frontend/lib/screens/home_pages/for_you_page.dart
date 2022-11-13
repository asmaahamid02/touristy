import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../exceptions/http_exception.dart';
import '../../utilities/utilities.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({
    Key? key,
  }) : super(key: key);

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
    await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
    // await Provider.of<Events>(context, listen: false).fetchAndSetEvents();
    // await Provider.of<Trips>(context, listen: false).fetchAndSetTrips();
    // await Provider.of<Travelers>(context, listen: false).fetchAndSetTravelers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: const CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
            sliver: SliverToBoxAdapter(
              child: TravelersAvatarsList(),
            ),
          ),
          // SliverPadding(
          //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          //   sliver: SliverToBoxAdapter(
          //     child: TripsList(),
          //   ),
          // ),
          // SliverPadding(
          //     padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          //     sliver: SliverToBoxAdapter(
          //       child: EventsList(),
          //     )),
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
        await Provider.of<Posts>(context).fetchAndSetPosts();
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
