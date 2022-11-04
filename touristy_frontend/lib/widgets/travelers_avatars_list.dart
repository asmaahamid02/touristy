import 'package:flutter/material.dart';
import './profile_avatar.dart';

class TravelersAvatarsList extends StatelessWidget {
  TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

  List<String> countries = [
    'US',
    'AF',
    'AL',
    'AZ',
    'AD',
    'AO',
    'AQ',
    'AG',
    'AR',
    'AM',
    'AW',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              'Travelers around the world',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProfileAvatar(
                    countryCode: countries[index],
                    imageUrl: 'https://picsum.photos/${index + 100}',
                    isActive: true,
                    hasFlag: true,
                  ),
                );
              },
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
