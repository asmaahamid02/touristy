import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
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

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).cardColor
          : null,
      appBar: AppBar(
        title: Text(username),
        actions: [
          userId == currentUser.id
              ? IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigator.of(context)
                    //     .pushNamed(EditProfileScreen.routeName);
                  },
                )
              : Container(),
        ],
      ),
      body: FutureBuilder<UserProfile>(
          future: _getUserProfile(context, userId),
          builder: (ctx, userProfileSnapshot) {
            if (userProfileSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (userProfileSnapshot.error != null) {
                debugPrint(userProfileSnapshot.error.toString());
                return Center(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'An error occurred! Try again later.',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                );
              } else {
                return const CustomScrollView(
                  slivers: [
                    ProfileHeader(),
                    ProfileInfo(),
                    ProfileFollowers(),
                    ProfileTabBar()
                  ],
                );
              }
            }
          }),
    );
  }
}
