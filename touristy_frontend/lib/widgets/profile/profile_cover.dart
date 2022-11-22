import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileCover extends StatelessWidget {
  ProfileCover({
    Key? key,
    this.topPositionForUserProfile = 85,
    this.coverImageHeight = 170,
    this.coverImageUrl,
    this.defaultImageProvider = const AssetImage('assets/images/map.png'),
    this.onTap,
  }) : super(key: key);

  final double topPositionForUserProfile;
  final double coverImageHeight;
  String? coverImageUrl;
  ImageProvider? defaultImageProvider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: coverImageHeight,
          margin: EdgeInsets.only(bottom: topPositionForUserProfile / 2),
          child: coverImageUrl != null
              ? CachedNetworkImage(
                  imageUrl: coverImageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: defaultImageProvider != null
                          ? defaultImageProvider!
                          : const AssetImage('assets/images/map.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        )

        // Container(
        //   margin: EdgeInsets.only(bottom: topPositionForUserProfile / 2),
        //   height: coverImageHeight,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: _coverImageUrl != null
        //           ? CachedNetworkImage(
        //               imageUrl: _coverImageUrl!,
        //               placeholder: (context, url) =>
        //                   const CircularProgressIndicator(),
        //               errorWidget: (context, url, error) =>
        //                   const Icon(Icons.error),
        //             ) as ImageProvider
        //           : defaultImageProvider != null
        //               ? defaultImageProvider!
        //               : const AssetImage('assets/images/map.png'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        );
  }
}
