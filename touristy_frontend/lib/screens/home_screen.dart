import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import './home_pages/for_you_page.dart';
import './home_pages/following_page.dart';
import './home_pages/map_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
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
            IconButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                },
                icon: const Icon(Icons.logout))
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'For you',
              ),
              Tab(
                text: 'Following',
              ),
              Tab(
                text: 'Map',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ForYouPage(),
            const FollowingPage(),
            MapPage(),
          ],
        ),
      ),
    );
  }
}
