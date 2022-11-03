import 'package:flutter/material.dart';
import '../widgets/user_avatar_with_flag.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String countryCode = 'us';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/main_logo.png',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 3.0,
            color: const Color.fromRGBO(124, 124, 124, 0.3),
          ),
        ),
      ),
      body: Column(children: [
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
        Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suggeted Events',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'See all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suggested Trips',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'See all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
