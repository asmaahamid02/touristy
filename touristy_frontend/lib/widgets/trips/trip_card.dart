import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:touristy_frontend/models/models.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.yMMMd().format(trip.arrivalDate);
    if (trip.departureDate != null) {
      date += ' - ${DateFormat.yMMMd().format(trip.departureDate!)}';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 0,
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          //flag
                          // const SizedBox(
                          //   width: 20,
                          //   height: 17,
                          //   child: ClipRRect(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(2)),
                          //     child: Flag.fromString(
                          //       'Indonesia',
                          //       fit: BoxFit.fill,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 8.0,
                          // ),
                          //country
                          Text(
                            trip.destination,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          //date
                          Text(
                            date,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
