import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/toast.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../utilities/utilities.dart';

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
      ToastCommon.show(error.toString());
    }
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
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(0),
                    child: SearchBar(searchController: _controller),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchUsers(_controller.text);
                  },
                ),
              ],
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
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                    sliver: SliverToBoxAdapter(child: TripsList()),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => PostContainer(
                        post: Post(
                            id: 1,
                            comments: 1,
                            likes: 2,
                            isLiked: true,
                            content: 'hello',
                            timeAgo: '1 hour ago',
                            user: User(
                              id: 1,
                              firstName: 'Asmaa',
                              lastName: 'Asmaa',
                              isFollowedByUser: false,
                            ))),
                  ))
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
          ToastCommon.show('No users found');
          return const SizedBox.shrink();
        }
      },
    );
  }
}
