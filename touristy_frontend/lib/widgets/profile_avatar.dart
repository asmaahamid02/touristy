import 'package:cached_network_image/cached_network_image.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    super.key,
    required this.onTap,
    required this.avatar,
    this.radius = 30.0,
  });

  final Avatar avatar;
  double radius;
  final Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: avatar.url != null
                ? CachedNetworkImageProvider(avatar.url!, headers: {
                    'Connection': 'keep-alive',
                  })
                : const AssetImage('assets/images/profile_picture.png')
                    as ImageProvider,
          ),
          if (avatar.isOnline != null && avatar.isOnline!)
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 69, 226, 74),
                ),
              ),
            ),
          if (avatar.countryCode != null && avatar.countryCode != '')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Flag.fromString(
                    avatar.countryCode!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
