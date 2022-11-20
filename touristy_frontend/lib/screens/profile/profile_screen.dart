import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/theme.dart';
import 'package:touristy_frontend/widgets/widgets.dart';

import '../../providers/providers.dart';
import '../../models/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  Future<UserProfile> _getUserProfile(BuildContext context, int userId) async {
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    await userProfileProvider.setUserProfile(userId);
    return userProfileProvider.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<Users>(context, listen: false).currentUser;
    int userId = currentUser.id;
    String username = '${currentUser.firstName} ${currentUser.lastName}';

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      final argsData = args as Map<String, dynamic>;
      userId = argsData['userId'];
      username = argsData['username'];
    }

    final brightness = Theme.of(context).brightness;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: FutureBuilder(
            future: _getUserProfile(context, userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                );
              }

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: brightness == Brightness.dark
                        ? AppColors.backgroundDarkGrey
                        : AppColors.backgroundWhite,
                    pinned: true,
                    floating: true,
                    title: Text(username),
                    actions: [
                      currentUser.id == userId
                          ? IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                // Navigator.of(context)
                                //     .pushNamed(EditProfileScreen.routeName);
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SliverToBoxAdapter(
                    child: ProfileHeader(),
                  ),
                  const SliverToBoxAdapter(
                    child: ProfileInfo(),
                  ),
                  const SliverToBoxAdapter(
                    child: ProfileFollowers(),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      _buildTabBar(brightness),
                    ),
                    pinned: true,
                  ),
                ],
                body: const TabBarView(
                  children: [
                    ProfilePostsList(),
                    ProfileTripsList(),
                  ],
                ),
              );
            }),
      ),
    );
  }

  TabBar _buildTabBar(Brightness brightness) {
    return TabBar(
      labelColor: brightness == Brightness.dark
          ? AppColors.textLight
          : AppColors.backgroundDarkGrey,
      indicatorColor: brightness == Brightness.dark
          ? AppColors.textLight
          : AppColors.backgroundDarkGrey,
      tabs: const [
        Tab(
          icon: Icon(Icons.grid_on),
        ),
        Tab(
          icon: Icon(Icons.airplanemode_on),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
