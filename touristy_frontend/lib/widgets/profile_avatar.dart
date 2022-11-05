import 'dart:io';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl = '',
    this.isActive = false,
    this.hasFlag = false,
    this.countryCode = '',
    this.radius = 30.0,
  });

  final String imageUrl;
  final bool isActive;
  final bool hasFlag;
  final String countryCode;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Users>(context).authToken as String;
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: imageUrl == ''
              ? const AssetImage('assets/images/profile_picture.png')
                  as ImageProvider
              : NetworkImage(imageUrl, headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                }),
        ),
        isActive
            ? Positioned(
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
              )
            : Container(),
        hasFlag
            ? Positioned(
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
              )
            : Container(),
      ],
    );
  }
}
