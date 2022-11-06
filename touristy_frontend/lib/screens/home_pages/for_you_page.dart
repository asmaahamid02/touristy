import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/posts/post_list.dart';
import '../../widgets/travelers_avatars_list.dart';
import '../../widgets/trips_list.dart';
import '../../widgets/events_list.dart';

import '../../providers/posts.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({
    Key? key,
  }) : super(key: key);

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
    // await Provider.of<Events>(context, listen: false).fetchAndSetEvents();
    // await Provider.of<Trips>(context, listen: false).fetchAndSetTrips();
    // await Provider.of<Travelers>(context, listen: false).fetchAndSetTravelers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: const CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
            sliver: SliverToBoxAdapter(
              child: TravelersAvatarsList(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
            sliver: SliverToBoxAdapter(
              child: TripsList(),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              sliver: SliverToBoxAdapter(
                child: EventsList(),
              )),
          PostsList(),
        ],
      ),
    );
  }
}
