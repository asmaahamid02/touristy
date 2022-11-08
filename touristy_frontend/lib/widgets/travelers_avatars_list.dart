import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import './profile_avatar.dart';

class TravelersAvatarsList extends StatelessWidget {
  const TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

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
          FutureBuilder(
            future:
                Provider.of<Users>(context, listen: false).fetchAndSetUsers(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return const Center(child: Text('An error occured, Refresh'));
                } else {
                  return Consumer<Users>(
                    builder: (context, usersData, child) => Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ProfileAvatar(
                              countryCode: usersData.users[index].countryCode,
                              imageUrl: usersData.users[index].profilePictureUrl
                                  as String,
                              isActive: true,
                              hasFlag: true,
                            ),
                          );
                        },
                        itemCount: usersData.users.length,
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  );
                }
              }
            }),
          )
        ],
      ),
    );
  }
}
