import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/utilities.dart';
import '../widgets.dart';
import '../../screens/screens.dart';
import '../../providers/providers.dart';

class ProfileTripsList extends StatefulWidget {
  const ProfileTripsList({super.key});

  @override
  State<ProfileTripsList> createState() => _ProfileTripsListState();
}

class _ProfileTripsListState extends State<ProfileTripsList> {
  int? userId;
  bool _isLoading = false;
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      ModalRoute.of(context)!.settings.arguments != null
          ? userId = ModalRoute.of(context)!.settings.arguments as int
          : userId = Provider.of<Auth>(context, listen: false).userId;

      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Trips>(context, listen: false).fetchTrips(userId!);
      } catch (error) {
        ToastCommon.show(error.toString());
      }
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const NewTripScreen()));
              },
            ),
          ),
        ),
        Expanded(
          child: Consumer<Trips>(
            builder: (context, tripsSnapshot, child) {
              return _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : tripsSnapshot.trips.isEmpty
                      ? const Center(
                          child: Text('No trips yet'),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tripsSnapshot.trips.length,
                          itemBuilder: (context, index) {
                            return TripCard(
                              trip: tripsSnapshot.trips[index],
                            );
                          },
                        );
            },
          ),
        ),
      ],
    );
  }
}
