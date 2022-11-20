import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/exceptions/http_exception.dart';
import '../../utilities/utilities.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});
  final Trip trip;

  Future<void> _deleteTrip(BuildContext context) async {
    final trips = Provider.of<Trips>(context, listen: false);
    final tripId = trip.id;

    try {
      await trips.deleteTrip(tripId!);
      ToastCommon.show('Trip deleted');
    } on HttpException catch (error) {
      ToastCommon.show('Error: ${error.toString()}');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete trip'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date = trip.arrivalDate != null
        ? DateFormat.yMMMd().format(trip.arrivalDate!)
        : '';
    if (trip.departureDate != null) {
      date += ' - ${DateFormat.yMMMd().format(trip.departureDate!)}';
    }

    int currentUserId = Provider.of<Auth>(context, listen: false).userId!;
    return trip.userId == currentUserId
        ? Dismissible(
            key: ValueKey(trip.id),
            background: Container(
              color: Theme.of(context).errorColor,
              child: const Icon(Icons.delete, size: 40, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => _showDeleteDialog(context),
            onDismissed: ((direction) {
              _deleteTrip(context);
            }),
            child: _TripCardItem(trip: trip, date: date),
          )
        : _TripCardItem(trip: trip, date: date);
  }
}

class _TripCardItem extends StatelessWidget {
  const _TripCardItem({
    Key? key,
    required this.trip,
    required this.date,
  }) : super(key: key);

  final Trip trip;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.red,
                            ),
                            Expanded(
                              child: Text(
                                trip.destination,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                            Expanded(
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
      ),
    );
  }
}
