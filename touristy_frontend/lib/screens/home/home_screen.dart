import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';
import '../../providers/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //show modal bottom sheet
  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: const NewPostScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            fit: BoxFit.cover,
            height: 40,
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/main_dark.png'
                : 'assets/images/main_logo.png',
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: _showModalBottomSheet,
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
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            indicatorColor: Theme.of(context).colorScheme.primary,
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
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ForYouPage(),
            FollowingPage(),
            MapPage(),
          ],
        ),
      ),
    );
  }
}
