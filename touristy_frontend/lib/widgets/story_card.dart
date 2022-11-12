import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import '../models/story_data.dart';
import '../widgets/widgets.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    Key? key,
    required this.storyData,
  }) : super(key: key);

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Stack(
            children: [
              Avatar.medium(
                imageUrl: storyData.url,
              ),
              if (storyData.isOnline != null && storyData.isOnline!)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 69, 226, 74),
                    ),
                  ),
                ),
              if (storyData.countryCode != null && storyData.countryCode != '')
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Flag.fromString(
                        storyData.countryCode!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
              width: 90.0,
              child: Text(
                storyData.name!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0),
              )),
        ),
      ],
    );
  }
}
