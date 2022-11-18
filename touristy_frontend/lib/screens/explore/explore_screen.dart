import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _controller = TextEditingController();

  Future<void> _searchUsers(String query) async {
    try {
      await Provider.of<SearchProvider>(context, listen: false)
          .searchUsers(query);
    } catch (error) {
      debugPrint('Users: $error');
    }
  }

  Future<void> _searchTrips(String query) async {
    try {
      await Provider.of<SearchProvider>(context, listen: false)
          .searchTrips(query);
    } catch (error) {
      debugPrint('Trips: $error');
    }
  }

  Future<void> _searchPosts(String query) async {
    try {
      await Provider.of<SearchProvider>(context, listen: false)
          .searchPosts(query);
    } catch (error) {
      debugPrint('Posts: $error');
    }
  }

  void _onChanged(value) {
    //delay search
    Future.delayed(const Duration(milliseconds: 1000), () {
      _searchUsers(value);
      _searchTrips(value);
      _searchPosts(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
        ),
        body: Column(
          children: [
            Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              child: SearchBar(
                  searchController: _controller, onChanged: _onChanged),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                    sliver: SliverToBoxAdapter(
                      child: _usersList(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                    sliver: SliverToBoxAdapter(
                      child: Consumer<SearchProvider>(
                        builder: (context, searchProvider, child) {
                          if (searchProvider.trips.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return TripsList(
                            trips: searchProvider.trips,
                          );
                        },
                      ),
                    ),
                  ),
                  Consumer<SearchProvider>(
                    builder: (context, searchProvider, child) {
                      if (searchProvider.posts.isEmpty) {
                        return const SliverToBoxAdapter(
                            child: SizedBox.shrink());
                      }
                      return SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PostContainer(
                            post: searchProvider.posts[index],
                          );
                        },
                        childCount: searchProvider.posts.length,
                      ));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _usersList extends StatelessWidget {
  const _usersList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.users.isNotEmpty) {
          return Card(
            elevation: 0,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: searchProvider.users.length,
                itemBuilder: (context, index) {
                  final User user = searchProvider.users[index];
                  return StoryCard(
                    storyData: StoryData(
                        id: user.id,
                        name: '${user.firstName} ${user.lastName}',
                        countryCode: user.nationality,
                        url: user.profilePictureUrl),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
