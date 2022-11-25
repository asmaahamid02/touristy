import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/utilities.dart';
import '../../providers/providers.dart';

class ProfileFollowers extends StatelessWidget {
  const ProfileFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).cardColor
        : null;
    return Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
      final profile = userProfileProvider.userProfile;
      return Card(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.secondary
            : Theme.of(context).cardColor,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextLabel(
                        textColor, profile.followers.toString(), 20),
                    _buildTextLabel(textColor, 'Followers', 16),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextLabel(
                        textColor, profile.followings.toString(), 20),
                    _buildTextLabel(textColor, 'Following', 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Text _buildTextLabel(Color? textColor, String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
