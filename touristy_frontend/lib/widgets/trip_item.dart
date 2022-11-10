import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class TripItem extends StatelessWidget {
  final bool withIcon;
  final String coverImageUrl;
  const TripItem(
      {super.key, this.withIcon = false, required this.coverImageUrl});

  static double get _coverTripImageHeight => 70;
  static double get _userProfileTripImageHeight => 40;

  static double get _topPositionForUserProfile =>
      _coverTripImageHeight - _userProfileTripImageHeight / 2;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.5,
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
                      child: Image.network(
                        coverImageUrl,
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
                      child: ProfileAvatar(
                          avatar: Avatar(
                            url: 'https://picsum.photos/200',
                          ),
                          onTap: (context) => print('tapped'),
                          radius: _userProfileTripImageHeight / 2),
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
