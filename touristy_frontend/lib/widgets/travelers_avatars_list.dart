import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../models/models.dart';
import './widgets.dart';

class TravelersAvatarsList extends StatelessWidget {
  const TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomUsers =
        Provider.of<Users>(context, listen: false).getRandomUsers(30);

    if (randomUsers.isNotEmpty) {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                'Travelers around the world',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Stories(
              storiesData: randomUsers
                  .map((user) => StoryData(
                      id: user.id,
                      name: '${user.firstName} ${user.lastName}',
                      url: user.profilePictureUrl,
                      countryCode: user.countryCode))
                  .toList(),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
