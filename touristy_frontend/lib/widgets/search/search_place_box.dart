import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../utilities/utilities.dart';
import '../../widgets/widgets.dart';

class SearchPlaceBox extends StatefulWidget {
  final String? initialSearchText;
  const SearchPlaceBox(
      {super.key, this.initialSearchText = 'Search for a destination'});

  @override
  State<SearchPlaceBox> createState() => _SearchPlaceBoxState();
}

class _SearchPlaceBoxState extends State<SearchPlaceBox> {
  final FocusNode _destinationFocusNode = FocusNode();
  final TextEditingController _destinationController = TextEditingController();

  var uuid = const Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _destinationController.addListener(() {
      _onChangedDestination();
    });
  }

  void _onChangedDestination() {
    if (_sessionToken == null) {
      if (mounted) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
    }
    getLocationResults(_destinationController.text);
  }

  Future<void> getLocationResults(String input) async {
    try {
      final response =
          await LocationHandler.getLocationResults(input, _sessionToken!);

      if (mounted) {
        setState(() {
          _placeList = response;
        });
      }
    } catch (error) {
      ToastCommon.show('Error: ${error.toString()}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _destinationFocusNode.dispose();
    _destinationController.dispose();
    _destinationController.removeListener(() {
      _onChangedDestination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //text field
        SearchTextField(
          focusNode: _destinationFocusNode,
          controller: _destinationController,
          labelText: widget.initialSearchText!,
          onTap: null,
          readOnly: false,
          autoFocus: true,
        ),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.95,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(_placeList[index]["description"]),
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                      onTap: () {
                        _destinationController.text =
                            _placeList[index]["description"];

                        Navigator.of(context).pop(_placeList[index]);
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        )

        //listview
      ],
    );
  }
}
