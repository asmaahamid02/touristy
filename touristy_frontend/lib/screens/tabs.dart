import 'package:flutter/material.dart';
import '../screens/explore_screen.dart';
import '../screens/messaging_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';

import '../screens/home_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  static const String routeName = '/tabs';
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List<Map<String, Object>> _pages = [];

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': const HomeScreen(),
      },
      {
        'page': const ExploreScreen(),
      },
      {
        'page': const ProfileScreen(),
      },
      {
        'page': const NotificationScreen(),
      },
      {
        'page': const MessagingScreen(),
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
