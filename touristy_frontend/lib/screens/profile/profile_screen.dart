import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).cardColor
            : null,
        appBar: AppBar(
          title: const Text('Han Mlo'),
        ),
        body: const CustomScrollView(
          slivers: [
            ProfileHeader(),
            ProfileInfo(),
            ProfileFollowers(),
            ProfileTabBar(),
          ],
        ));
  }
}
