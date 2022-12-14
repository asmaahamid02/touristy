import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class MessageInput extends StatelessWidget {
  MessageInput(
      {super.key,
      required this.sendMessage,
      this.placeHolder = 'Type a message...'});
  final Function(String message) sendMessage;
  final TextEditingController _messageController = TextEditingController();
  final String placeHolder;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SafeArea(
      bottom: true,
      top: false,
      child: Card(
        elevation: 0.0,
        color: brightness == Brightness.light
            ? AppColors.backgroundLightGrey
            : Theme.of(context).cardColor,
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
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                hintText: placeHolder,
                border: InputBorder.none,
              ),
              controller: _messageController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                sendMessage(_messageController.text);
                _messageController.clear();
              },
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
