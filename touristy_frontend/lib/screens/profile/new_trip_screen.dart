import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});
  static const routeName = '/new-trip';
  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _openDestinationFocusNode = FocusNode();

  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? firstArriDate;
  DateTime? lastArriDate;

  DateTime? firstDepDate;
  DateTime? lastDepDate;

  bool _isPastTrip = false;

  final TextEditingController _openDestinationController =
      TextEditingController();

  double? _longitude;
  double? _latitude;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    firstArriDate = DateTime.now();
    lastArriDate = DateTime.now().add(const Duration(days: 365));
    _arrivalDateController.text = firstArriDate!.toString();

    firstDepDate = DateTime.now().add(const Duration(days: 1));
    lastDepDate = DateTime.now().add(const Duration(days: 366));
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

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Trips>(context, listen: false).addTrip(
        Trip(
          title: _titleController.text,
          description: _descriptionController.text,
          arrivalDate:
              _isPastTrip ? null : DateTime.parse(_arrivalDateController.text),
          departureDate: _isPastTrip
              ? null
              : _departureDateController.text.isEmpty
                  ? null
                  : DateTime.parse(_departureDateController.text),
          destination: _openDestinationController.text,
          longitude: _longitude,
          latitude: _latitude,
        ),
      );

      Navigator.of(context).pop();
    } catch (error) {
      ToastCommon.show(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _openDestinationFocusNode.dispose();
    _arrivalDateController.dispose();
    _departureDateController.dispose();
    _openDestinationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).cardColor
              : null,
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
              //title
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                autofocus: true,
                textInputAction: TextInputAction.next,
                focusNode: _titleFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                controller: _titleController,
              ),
              const SizedBox(height: 16),
              //description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                controller: _descriptionController,
              ),
              const SizedBox(height: 16),
              SearchTextField(
                focusNode: _openDestinationFocusNode,
                controller: _openDestinationController,
                labelText: 'Search for destination',
                onTap: _openDestinationSearchDialog,
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please choose a destination';
                  }
                  return null;
                },
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
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(textLabel: 'ADD TRIP', onTap: _saveTrip),
      ],
    );
  }
}
