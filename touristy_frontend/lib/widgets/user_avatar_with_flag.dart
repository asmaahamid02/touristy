import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class UserAvatarWithFlag extends StatelessWidget {
  UserAvatarWithFlag({
    Key? key,
    required this.countryCode,
    this.avatarUrl,
  }) : super(key: key);

  final String countryCode;
  String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: avatarUrl == null
              ? AssetImage('assets/images/profile_picture.png') as ImageProvider
              : NetworkImage(avatarUrl as String),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        ),
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
                countryCode,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
