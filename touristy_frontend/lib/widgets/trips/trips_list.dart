import 'package:flutter/material.dart';
import '../widgets.dart';
import '../../models/models.dart';

class TripsList extends StatelessWidget {
  const TripsList({
    Key? key,
    required this.trips,
  }) : super(key: key);
  final List<Trip> trips;
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
            child: const Text(
              'Trips by travelers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TripItem(
                    trip: trips[index],
                  ),
                );
              },
              itemCount: trips.length,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
