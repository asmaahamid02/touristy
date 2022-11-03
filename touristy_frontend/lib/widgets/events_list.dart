import 'package:flutter/material.dart';
import '../widgets/event_item.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
        Container(
          height: 210,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(124, 124, 124, 0.3),
                width: 3.0,
              ),
            ),
          ),
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                EventItem(),
                SizedBox(width: 15),
                EventItem(),
                SizedBox(width: 15),
                EventItem(),
                SizedBox(width: 15),
                EventItem(),
              ]),
        ),
      ],
    );
  }
}
