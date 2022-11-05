import 'package:flutter/material.dart';
import '../../widgets/posts/post_list.dart';
import '../../widgets/travelers_avatars_list.dart';
import '../../widgets/trips_list.dart';
import '../../widgets/events_list.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
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
        PostsList()
      ],
    );
  }
}
