import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({super.key, this.imageUrl, required this.radius});
  Avatar.small({super.key, this.imageUrl}) : radius = 16.0;
  Avatar.medium({super.key, this.imageUrl}) : radius = 27.0;
  Avatar.large({super.key, this.imageUrl}) : radius = 44.0;

  String? imageUrl;
  final double radius;

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
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Image.asset('assets/images/profile_picture.png'),
    );
  }
}
