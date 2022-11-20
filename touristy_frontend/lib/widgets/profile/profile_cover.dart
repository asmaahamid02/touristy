import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileCover extends StatelessWidget {
  ProfileCover({
    Key? key,
    this.topPositionForUserProfile = 85,
    this.coverImageHeight = 170,
    String? coverImageUrl,
    this.defaultImageProvider = const AssetImage('assets/images/map.png'),
    this.onTap,
  })  : _coverImageUrl = coverImageUrl,
        super(key: key);

  final double topPositionForUserProfile;
  final double coverImageHeight;
  final String? _coverImageUrl;
  ImageProvider? defaultImageProvider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: topPositionForUserProfile / 2),
        height: coverImageHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _coverImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: _coverImageUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ) as ImageProvider
                : defaultImageProvider != null
                    ? defaultImageProvider!
                    : const AssetImage('assets/images/map.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
