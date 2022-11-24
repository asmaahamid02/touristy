import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({
    super.key,
    this.imageUrl,
    required this.radius,
    this.defaultImageProvider =
        const AssetImage('assets/images/profile_picture.png'),
  });

  Avatar.small({super.key, this.imageUrl}) : radius = 16.0;
  Avatar.medium({super.key, this.imageUrl}) : radius = 27.0;
  Avatar.large({super.key, this.imageUrl}) : radius = 44.0;

  String? imageUrl;
  final double radius;
  ImageProvider? defaultImageProvider;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).cardColor,
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => _buildDefaultImage(),
            )
          : _buildDefaultImage(),
    );
  }

  Container _buildDefaultImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: defaultImageProvider != null
              ? defaultImageProvider!
              : const AssetImage('assets/images/profile_picture.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
