import 'package:flutter/material.dart';
import '../widgets/trip_item.dart';

class TripsList extends StatelessWidget {
  const TripsList({
    Key? key,
  }) : super(key: key);

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
                'Trips by travelers',
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
              children: const [
                TripItem(withIcon: true),
                SizedBox(width: 15),
                TripItem(withIcon: false),
                SizedBox(width: 15),
                TripItem(withIcon: false),
                SizedBox(width: 15),
                TripItem(withIcon: false),
              ]),
        ),
      ],
    );
  }
}
