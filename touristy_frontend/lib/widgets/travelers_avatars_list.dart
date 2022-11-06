import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import './profile_avatar.dart';

class TravelersAvatarsList extends StatefulWidget {
  const TravelersAvatarsList({
    Key? key,
  }) : super(key: key);

  @override
  State<TravelersAvatarsList> createState() => _TravelersAvatarsListState();
}

class _TravelersAvatarsListState extends State<TravelersAvatarsList> {
  var _isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Users>(context).fetchAndSetUsers();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Users>(context);
    final users = usersData.users;
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
                    countryCode: users[index].countryCode,
                    imageUrl: users[index].profilePictureUrl as String,
                    isActive: true,
                    hasFlag: true,
                  ),
                );
              },
              itemCount: users.length,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
