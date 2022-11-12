import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.all(0.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.photo_camera,
                color: AppColors.secondary,
                size: 20.0,
              ),
            ),
          ),
          const Expanded(
            child: TextField(
              style: TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: AppColors.secondary,
                size: 20.0,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
