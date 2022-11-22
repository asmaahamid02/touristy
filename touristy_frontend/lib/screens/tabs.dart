import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/exceptions/http_exception.dart';
import '../screens/screens.dart';
import '../providers/providers.dart';
import '../utilities/utilities.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  static const String routeName = '/tabs';
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List<Map<String, Object>> _pages = [];

  int _selectedPageIndex = 0;

  final _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _pages = [
      {'page': const HomeScreen(), 'title': 'Home', 'icon': Icons.home},
      {'page': const ExploreScreen(), 'title': 'Explore', 'icon': Icons.search},

      // {
      //   'page': const NotificationScreen(),
      //   'title': 'Notifications',
      //   'icon': Icons.notifications_active
      // },
      {
        'page': const MessagingScreen(),
        'title': 'Messages',
        'icon': Icons.message_rounded
      },
      {
        'page': const ProfileScreen(),
        'title': 'Profile',
        'icon': Icons.account_circle
      },
    ];
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
      } on HttpException catch (error) {
        //show error snackbar
        SnakeBarCommon.show(context, error.toString());
      } catch (error) {
        debugPrint(error.toString());
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        // showSelectedLabels: true,
        // showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        // unselectedItemColor: Colors.grey[600],
        selectedItemColor: AppColors.secondary,
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
