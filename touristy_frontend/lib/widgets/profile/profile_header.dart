import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../../screens/screens.dart';
import '../../models/models.dart';

class ProfileHeader extends StatelessWidget {
  final coverImageHeight = 170.0;
  final topPositionForUserProfile = 120.0;
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
      final profile = userProfileProvider.userProfile;
      return Card(
        elevation: 0,
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).cardColor
            : Theme.of(context).scaffoldBackgroundColor,
        margin: const EdgeInsets.all(0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileCover(
              coverImageUrl: profile.coverPictureUrl,
            ),
            //add overlay
            _buildOverlay(),
            //added user profile image
            ProfileAvatar(
              imaegUrl: profile.profilePictureUrl,
            ),

            _buildProfileButtons(profile, context),
          ],
        ),
      );
    });
  }

  Positioned _buildProfileButtons(UserProfile profile, BuildContext context) {
    final currentUser = Provider.of<Users>(context, listen: false).currentUser;
    return Positioned(
      top: topPositionForUserProfile + 20,
      right: 0,
      child: Row(
        children: [
          if (currentUser.id != profile.id)
            Consumer<Users>(
              builder: (context, usersProvider, child) {
                return _buildFollowButton(usersProvider, profile, context);
              },
            ),
          const SizedBox(width: 10),
          currentUser.id == profile.id
              ? _buildEditProfile(context, profile)
              : _buildMessageButton(context, profile),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  ProfileButton _buildEditProfile(BuildContext context, UserProfile profile) {
    return ProfileButton(
      icon: Icons.edit,
      label: 'EDIT Profile',
      textColor: AppColors.secondary,
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamed(EditProfileScreen.routeName,
            arguments: {'userId': profile.id!});
      },
    );
  }

  ProfileButton _buildFollowButton(
      Users usersProvider, UserProfile profile, BuildContext context) {
    final isFollowing = usersProvider.isFollowed(profile.id!);
    return ProfileButton(
      icon: profile.isFollowedByUser! ? Icons.person : Icons.person_add,
      label: isFollowing ? 'UNFOLLOW' : 'FOLLOW',
      textColor: Colors.white,
      color: AppColors.secondary,
      onPressed: () {
        _followUser(usersProvider, profile, context);
      },
    );
  }

  Positioned _buildOverlay() {
    return Positioned(
      child: Container(
        height: coverImageHeight,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }

  ProfileButton _buildMessageButton(BuildContext context, UserProfile profile) {
    return ProfileButton(
      icon: Icons.message,
      label: 'MESSAGE',
      textColor: AppColors.secondary,
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: MessageData(
            senderId: profile.id!,
            senderName: '${profile.firstName} ${profile.lastName}',
            profilePicture: profile.profilePictureUrl,
          ),
        );
      },
    );
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
