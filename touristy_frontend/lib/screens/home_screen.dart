import 'package:flutter/material.dart';
import '../widgets/events_list.dart';
import '../widgets/travelers_avatars_list.dart';
import '../widgets/trips_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
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
      body: SingleChildScrollView(
        child: Column(children: [
          TravelersAvatarsList(),
          EventsList(),
          TripsList(),
        ]),
      ),
    );
  }
}
