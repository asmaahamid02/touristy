import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/providers/providers.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
      final profile = userProfileProvider.userProfile;
      final age = DateTime.now().year -
          DateFormat('MMM d, y').parse(profile.birthDate!).year;
      return Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).cardColor
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profile.firstName} ${profile.lastName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (profile.address != null) const SizedBox(height: 10),
              if (profile.address != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        profile.address!.split(',').last,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Flag.fromString(
                        profile.countryCode!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (profile.gender!.toLowerCase() != 'other')
                    Text(
                      '${profile.gender!.substring(0, 1).toUpperCase()}${profile.gender!.substring(1)}, $age years old',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              if (profile.bio != null) const SizedBox(height: 10),
              if (profile.bio != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    profile.bio!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
