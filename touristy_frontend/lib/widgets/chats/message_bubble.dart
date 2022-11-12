import 'package:flutter/material.dart';
import '../widgets.dart';
import '../../utilities/utilities.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      this.isMe = false,
      required this.message,
      required this.time,
      this.avatarUrl});

  final bool isMe;
  final String message;
  final String time;
  String? avatarUrl;

  static const double _avatarRadius = 6.0;
  static const double _containerRadius = 26.0;
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).cardColor : AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(_containerRadius),
                  topRight: Radius.circular(isMe ? 0.0 : _containerRadius),
                  bottomLeft: Radius.circular(isMe ? _containerRadius : 0.0),
                  bottomRight: const Radius.circular(_containerRadius),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  message,
                  style: TextStyle(
                      color: isMe
                          ? brightness == Brightness.light
                              ? AppColors.textDark
                              : AppColors.textLight
                          : AppColors.textLight),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMe)
                    Avatar(radius: _avatarRadius, imageUrl: avatarUrl ?? ''),
                  if (!isMe) const SizedBox(width: 4.0),
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 10.0, color: AppColors.textFaded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
