import 'package:flutter/material.dart';
import './user_avatar_with_flag.dart';

class TravelersAvatarsList extends StatelessWidget {
  const TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

  final String countryCode = 'us';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text(
            'Travelers around the world',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(124, 124, 124, 0.3),
                width: 3.0,
              ),
            ),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              UserAvatarWithFlag(
                countryCode: countryCode,
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
              SizedBox(width: 15),
              UserAvatarWithFlag(
                countryCode: countryCode,
                avatarUrl: 'https://picsum.photos/200',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
