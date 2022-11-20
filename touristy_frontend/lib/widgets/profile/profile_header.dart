import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../../screens/screens.dart';
import '../../models/models.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  static double get _coverTripImageHeight => 170;
  static double get _userProfileImageHeight => 100;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileImageHeight / 2;
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Users>(context, listen: false).currentUser;

    return Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
      final profile = userProfileProvider.userProfile;
      return Card(
        elevation: 0,
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).cardColor
            : Theme.of(context).scaffoldBackgroundColor,
        margin: const EdgeInsets.all(0),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            margin: EdgeInsets.only(bottom: _topPositionForUserProfile / 2),
            height: _coverTripImageHeight,
            child: ClipRRect(
              child: profile.coverPictureUrl != null
                  ? CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/200/800',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),
          //add overlay
          Positioned(
            child: Container(
              height: _coverTripImageHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          //added user profile image
          Positioned(
            top: _topPositionForUserProfile,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.textFaded
                      : AppColors.backgroundLightGrey,
                  width: 1,
                ),
              ),
              child: Avatar(
                  radius: _userProfileImageHeight / 2,
                  imageUrl: profile.profilePictureUrl),
            ),
          ),

          Positioned(
            top: _topPositionForUserProfile + 20,
            right: 0,
            child: Row(
              children: [
                if (currentUser.id != profile.id)
                  Consumer<Users>(
                    builder: (context, usersProvider, child) {
                      final isFollowing = usersProvider.isFollowed(profile.id!);
                      return ProfileButton(
                        icon: profile.isFollowedByUser!
                            ? Icons.person
                            : Icons.person_add,
                        label: isFollowing ? 'UNFOLLOW' : 'FOLLOW',
                        textColor: Colors.white,
                        color: AppColors.secondary,
                        onPressed: () {
                          _followUser(usersProvider, profile, context);
                        },
                      );
                    },
                  ),
                const SizedBox(
                  width: 10,
                ),
                currentUser.id == profile.id
                    ? ProfileButton(
                        icon: Icons.edit,
                        label: 'EDIT Profile',
                        textColor: AppColors.secondary,
                        color: Colors.white,
                        onPressed: () {},
                      )
                    : ProfileButton(
                        icon: Icons.message,
                        label: 'MESSAGE',
                        textColor: AppColors.secondary,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            ChatScreen.routeName,
                            arguments: MessageData(
                              senderId: profile.id!,
                              senderName: profile.name!,
                              profilePicture: profile.profilePictureUrl,
                            ),
                          );
                        },
                      ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }

  void _followUser(
      Users usersProvider, UserProfile profile, BuildContext context) {
    usersProvider.followUser(profile.id!).then((response) {
      ToastCommon.show(response);
    });

    final user = usersProvider.findUserById(profile.id!);
    Provider.of<UserProfileProvider>(context, listen: false)
        .followUser(user.isFollowedByUser!);
  }
}
