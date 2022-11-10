import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(bottom: 10),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suggeted Events',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  'See all',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: EventItem(
                    eventImageUrl: 'https://picsum.photos/${index + 100}',
                  ),
                );
              },
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
