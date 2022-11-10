import 'package:flutter/material.dart';
import '../screens/screens.dart';

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
      {'page': const HomeScreen(), 'title': 'Home', 'icon': Icons.home},
      {'page': const ExploreScreen(), 'title': 'Explore', 'icon': Icons.search},
      {
        'page': const ProfileScreen(),
        'title': 'Profile',
        'icon': Icons.account_circle
      },
      {
        'page': const NotificationScreen(),
        'title': 'Notifications',
        'icon': Icons.notifications_active
      },
      {
        'page': const MessagingScreen(),
        'title': 'Messages',
        'icon': Icons.message_rounded
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
        // unselectedItemColor: Colors.grey[600],
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: _pages
            .map((page) => BottomNavigationBarItem(
                icon: Icon(page['icon'] as IconData),
                label: page['title'] as String))
            .toList(),
      ),
    );
  }
}
