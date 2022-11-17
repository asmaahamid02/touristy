import 'package:flutter/material.dart';
import '../widgets.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.airplanemode_on),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const TabBarView(children: [
                PostsGrid(),
                TripsList(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
