import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/models.dart';

class MapPage extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  static const routeName = '/map';
  const MapPage({
    Key? key,
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
  late GoogleMapController mapController;

  late LatLng _center;

  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();

    _center = LatLng(
        widget.initialLocation.latitude!, widget.initialLocation.longitude!);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : (() => Navigator.of(context).pop(_pickedLocation)),
            ),
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16,
          ),
          onTap: widget.isSelecting ? _selectLocation : null,
          myLocationEnabled: true,
          markers: _pickedLocation == null
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId('m1'),
                      position: _pickedLocation!)
                },
        ),
      ),
    );
  }
}
