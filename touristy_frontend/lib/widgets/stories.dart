import 'package:flutter/material.dart';
import './widgets.dart';
import '../models/models.dart';

class Stories extends StatelessWidget {
  const Stories({
    Key? key,
    required this.storiesData,
  }) : super(key: key);

  final List<StoryData> storiesData;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: storiesData.length,
          itemBuilder: (context, index) {
            return StoryCard(storyData: storiesData[index]);
          },
        ),
      ),
    );
  }
}
