import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});
  static const routeName = '/new-trip';
  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _arrivalDateFocusNode = FocusNode();
  final FocusNode _departureDateFocusNode = FocusNode();
  final FocusNode _openDestinationFocusNode = FocusNode();

  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController =
      TextEditingController();

  DateTime? firstArriDate;
  DateTime? lastArriDate;

  DateTime? firstDepDate;
  DateTime? lastDepDate;

  bool _isPastTrip = false;

  final TextEditingController _openDestinationController =
      TextEditingController();

  double? _longitude;
  double? _latitude;

  @override
  void initState() {
    super.initState();
    firstArriDate = DateTime.now();
    lastArriDate = DateTime.now().add(const Duration(days: 365));
    _arrivalDateController.text = firstArriDate!.toString();

    firstDepDate = DateTime.now().add(const Duration(days: 1));
    lastDepDate = DateTime.now().add(const Duration(days: 366));
  }

  @override
  void dispose() {
    super.dispose();
    _arrivalDateFocusNode.dispose();
    _departureDateFocusNode.dispose();
    _openDestinationFocusNode.dispose();
    _arrivalDateController.dispose();
    _departureDateController.dispose();
    _openDestinationController.dispose();
  }

  void changeDate(String value, TextEditingController controller) {
    setState(() {
      controller.text = value;
    });
  }

  Future<void> _openDestinationSearchDialog() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            scrollable: true,
            content: SearchPlaceBox(),
          );
        });
    if (result != null) {
      setState(() {
        _openDestinationController.text = result['description'];
      });

//get the latitude and longitude of the place
      try {
        final place = await LocationHandler.getPlaceDetails(result['place_id']);
        _latitude = place['geometry']['location']['lat'];
        _longitude = place['geometry']['location']['lng'];
      } catch (error) {
        ToastCommon.show(error.toString());
      }
    }
  }

//save the trip
  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('New Trip'),
          ),
          body: Stack(
            children: [
              Form(key: _formKey, child: _buildForm()),
            ],
          )),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SearchTextField(
                focusNode: _openDestinationFocusNode,
                controller: _openDestinationController,
                labelText: 'Search for destination',
                onTap: _openDestinationSearchDialog,
                readOnly: true,
              ),
              _isPastTrip
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        TripDateTimePicker(
                            dateLabel: 'Arrival Date',
                            firstDate: firstArriDate!,
                            lastDate: lastArriDate!,
                            controller: _arrivalDateController,
                            initialValue: firstArriDate.toString(),
                            changeDate: changeDate),
                        const SizedBox(height: 16),
                        TripDateTimePicker(
                            dateLabel: 'Departure Date',
                            firstDate: firstDepDate!,
                            lastDate: lastDepDate!,
                            controller: _departureDateController,
                            initialValue: null,
                            changeDate: changeDate),
                      ],
                    ),
              //checkboxe if past trip or not
              const SizedBox(height: 16),
              //switch button
              SwitchListTile(
                title: const Text('Past Trip'),
                value: _isPastTrip,
                onChanged: (value) {
                  setState(() {
                    _isPastTrip = value;
                  });
                },
                secondary: const Icon(Icons.history),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        PrimaryButton(textLabel: 'ADD TRIP', onTap: () {})
      ],
    );
  }
}
