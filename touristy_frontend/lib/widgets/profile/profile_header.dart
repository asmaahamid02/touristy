import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader();
  static double get _coverTripImageHeight => 170;
  static double get _userProfileImageHeight => 100;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileImageHeight / 2;
  @override
  Widget build(BuildContext context) {
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
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/200/800',
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
          child: CircleAvatar(
            radius: _userProfileImageHeight / 2,
            backgroundImage: const CachedNetworkImageProvider(
                'https://picsum.photos/200/100'),
          ),
        ),
        //added buttons edit profile and follow button
        Positioned(
          top: _topPositionForUserProfile + 20,
          right: 0,
          child: Row(
            children: [
              ProfileButton(
                icon: Icons.add,
                label: 'FOLLOW',
                textColor: Colors.white,
                color: AppColors.secondary,
                onPressed: () {},
              ),
              const SizedBox(
                width: 10,
              ),
              ProfileButton(
                  icon: Icons.edit,
                  label: 'EDIT PROFILE',
                  textColor: AppColors.secondary,
                  color: Colors.white,
                  onPressed: () {}),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}
