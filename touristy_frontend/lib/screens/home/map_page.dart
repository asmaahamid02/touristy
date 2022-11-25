import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../screens/screens.dart';
import '../../models/models.dart';
import '../../utilities/utilities.dart';
import '../../providers/providers.dart';

class MapPage extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  final bool isViewing;

  static const routeName = '/map';
  const MapPage({
    Key? key,
    this.isViewing = true,
    this.initialLocation = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
    ),
    this.isSelecting = false,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _center;
  String? imageUrl;
  final int targetWidth = 100;
  late final List<MarkerData> _customMarkers = [];
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      final currentUser =
          Provider.of<Users>(context, listen: false).currentUser;

      try {
        final position = await LocationHandler.getCurrentPosition(context);

        await Provider.of<Trips>(context, listen: false)
            .fetchTripsByUser(currentUser.id);

        final currentUserTrips =
            Provider.of<Trips>(context, listen: false).trips;
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          _customMarkers.add(
            MarkerData(
              marker: Marker(
                markerId: const MarkerId('id-0'),
                position: _center!,
                onTap: () =>
                    Navigator.of(context).pushNamed(ProfileScreen.routeName),
              ),
              child: _customMarker(numberOfTrips: currentUserTrips.length),
            ),
          );
        });

        final locations = Provider.of<Locations>(context, listen: false);
        await locations.fetchLocations();
        final locationList = locations.tripsLocations;

        if (locationList != null && locationList.isNotEmpty) {
          int id = 1;

          for (var element in locationList) {
            _customMarkers.add(
              MarkerData(
                marker: Marker(
                  markerId: MarkerId('id-${id.toString()}'),
                  position: LatLng(element.latitude!, element.longitude!),
                ),
                child: _customMarker(numberOfTrips: element.count!),
              ),
            );
            id++;
          }
          setState(() {});
        }
      } catch (error) {
        debugPrint('error : $error');
      }

      _isInit = false;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _center == null
          ? const Center(child: CircularProgressIndicator())
          :
          // Container(child: const Text('map')),
          CustomGoogleMapMarkerBuilder(
              customMarkers: _customMarkers,
              builder: (BuildContext context, Set<Marker>? markers) {
                if (markers == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 14.4746,
                  ),
                  markers: markers,
                  onMapCreated: _onMapCreated,
                );
              },
            ),
    );
  }

  _customMarker({int? numberOfTrips}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.secondary, width: 2),
              color: Colors.white,
            ),
            child: const Icon(
              Icons.airplanemode_active,
              size: 30,
              color: AppColors.secondary,
            )),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '${numberOfTrips ?? 0}+',
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        )
      ],
    );
  }
}
