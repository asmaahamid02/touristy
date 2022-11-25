import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';
import '../widgets.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    Key? key,
    this.topPositionForUserProfile = 120.0,
    this.userProfileImageHeight = 100,
    String? imaegUrl,
    this.defaultImageProvider,
    this.onTap,
  })  : _imaegUrl = imaegUrl,
        super(key: key);

  final double topPositionForUserProfile;
  final double userProfileImageHeight;
  final String? _imaegUrl;
  ImageProvider? defaultImageProvider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPositionForUserProfile,
      left: 16,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
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
            radius: userProfileImageHeight / 2,
            imageUrl: _imaegUrl,
            defaultImageProvider: defaultImageProvider,
          ),
        ),
      ),
    );
  }
}
