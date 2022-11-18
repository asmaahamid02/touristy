import 'package:flutter/material.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.red,
      child: Column(
        children: const [
          //text field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for a destination',
              border: InputBorder.none,
            ),
          ),

          //listview
        ],
      ),
    );
  }
}
