import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';
import '../widgets.dart';

class ProfileTripsList extends StatelessWidget {
  const ProfileTripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            width: 150,
            child: ProfileButton(
              label: 'ADD TRIP',
              icon: Icons.airplanemode_active,
              color: AppColors.secondary,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      //flag
                                      SizedBox(
                                        width: 20,
                                        height: 17,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          child: Flag.fromString(
                                            'mm',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      //country
                                      Text(
                                        'Myanmar',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      //date
                                      Text(
                                        'Aug 16 - Aug 20 2020',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
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
              },
              itemCount: 20),
        ),
      ],
    );
  }
}
