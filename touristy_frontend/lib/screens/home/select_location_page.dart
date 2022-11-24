import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristy_frontend/widgets/search/search_place_box.dart';
import 'package:touristy_frontend/widgets/search/search_text_field.dart';
import '../../models/models.dart';
import '../../utilities/utilities.dart';

class SelectLocation extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  final bool isViewing;

  static const routeName = '/select-location';
  const SelectLocation({
    Key? key,
    this.isViewing = true,
    this.initialLocation = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
    ),
    this.isSelecting = false,
  }) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _center;
  LatLng? _pickedLocation;

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final bool _showSearchResults = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    try {
      final position = await LocationHandler.getCurrentPosition(context);
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> _openSearchDialog() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            scrollable: true,
            content: SearchPlaceBox(
              initialSearchText: 'Search for location',
            ),
          );
        });
    if (result != null) {
      setState(() {
        _searchController.text = result['description'];
      });

      //get the latitude and longitude of the place
      try {
        final place = await LocationHandler.getPlaceDetails(result['place_id']);
        _pickedLocation = LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']);
        setState(() {});
        //change the camera position to the selected location
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _pickedLocation!,
            zoom: 16,
          ),
        ));
      } catch (error) {
        ToastCommon.show(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
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
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: _center == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center!,
                      zoom: 11.0,
                    ),
                    onTap: _selectLocation,
                    myLocationEnabled: true,
                    markers: _pickedLocation == null
                        ? {
                            Marker(
                              markerId: const MarkerId('m1'),
                              position: _center!,
                            ),
                          }
                        : {
                            Marker(
                                markerId: const MarkerId('m1'),
                                position: _pickedLocation!)
                          },
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).cardColor,
                        ),
                        child: SearchTextField(
                          controller: _searchController,
                          labelText: 'Search for location',
                          border: InputBorder.none,
                          onTap: _openSearchDialog,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
