import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class TripItem extends StatelessWidget {
  final Trip trip;
  const TripItem({super.key, required this.trip});

  static double get _coverTripImageHeight => 70;
  static double get _userProfileTripImageHeight => 40;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileTripImageHeight / 2;

  @override
  Widget build(BuildContext context) {
    final user =
        Provider.of<Users>(context, listen: false).findUserById(trip.userId!);
    return Card(
      elevation: 3.5,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 200,
        width: 150,
        child: Column(
          children: [
            Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: _topPositionForUserProfile / 2),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.asset('assets/images/map.png'),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: _topPositionForUserProfile / 2),
                      height: _coverTripImageHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                  ),
                  Positioned(
                    top: _topPositionForUserProfile,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Avatar(
                          imageUrl: user.profilePictureUrl!,
                          radius: _userProfileTripImageHeight / 2),
                    ),
                  )
                ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      trip.destination,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
