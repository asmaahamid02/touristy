import 'dart:io';

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
      backgroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!, headers: {
              HttpHeaders.connectionHeader: 'keep-alive',
            })
          : const AssetImage('assets/images/profile_picture.png')
              as ImageProvider,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
