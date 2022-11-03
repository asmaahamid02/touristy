import 'package:flutter/material.dart';

class TripItem extends StatelessWidget {
  const TripItem({super.key, required this.withIcon});

  final bool withIcon;

  static double get _coverTripImageHeight => 70;
  static double get _userProfileTripImageHeight => 40;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileTripImageHeight / 2;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://picsum.photos/250?image=9',
                        width: double.infinity,
                        height: _coverTripImageHeight,
                        fit: BoxFit.cover,
                      ),
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
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: _userProfileTripImageHeight / 2,
                        backgroundImage: const AssetImage(
                            'assets/images/profile_picture.png'),
                      ),
                    ),
                  )
                ]),
            withIcon
                ? TextButton(
                    onPressed: null,
                    child: Column(
                      children: [
                        Icon(
                          Icons.airplanemode_active,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Add Trip',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'User name',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Trip Location',
                          style: Theme.of(context).textTheme.bodySmall,
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
