import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../../screens/screens.dart';
import '../../models/models.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader();
  static double get _coverTripImageHeight => 170;
  static double get _userProfileImageHeight => 100;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileImageHeight / 2;
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Users>(context, listen: false).currentUser;
    final profile =
        Provider.of<UserProfileProvider>(context, listen: false).userProfile;

    return SliverToBoxAdapter(
      child: Card(
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
            child: Avatar(
                radius: _userProfileImageHeight / 2,
                imageUrl: profile.profilePictureUrl),
          ),

          Positioned(
            top: _topPositionForUserProfile + 20,
            right: 0,
            child: Row(
              children: [
                if (currentUser.id != profile.id)
                  ProfileButton(
                    icon: profile.isFollowedByUser!
                        ? Icons.person
                        : Icons.person_add,
                    label: profile.isFollowedByUser! ? 'UNFOLLOW' : 'FOLLOW',
                    textColor: Colors.white,
                    color: AppColors.secondary,
                    onPressed: () {},
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
      ),
    );
  }
}
