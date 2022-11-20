import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.airplanemode_on),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const TabBarView(children: [
                ProfilePostsList(),
                ProfileTripsList(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePostsList extends StatelessWidget {
  const ProfilePostsList({super.key});

  Future<List<Post>> _fetchPosts(BuildContext context) async {
    final UserPosts userPosts = Provider.of<UserPosts>(context, listen: false);

    final int userId = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfile
        .id!;
    await userPosts.fetchAndSetPosts(userId);
    return userPosts.posts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _fetchPosts(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.error != null) {
            return const Center(
              child: Text('An error occurred!}'),
            );
          } else {
            return Consumer<UserPosts>(
              builder: (ctx, userPosts, child) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userPosts.posts.length,
                  itemBuilder: (ctx, index) {
                    return PostContainer(
                      post: userPosts.posts[index],
                    );
                  },
                );
              },
            );
          }
        }
      },
    );
  }
}
