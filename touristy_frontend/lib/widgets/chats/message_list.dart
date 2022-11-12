import 'package:flutter/material.dart';
import '../widgets.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListView(
        children: [
          const ChatDateLabel(label: 'Today'),
          MessageBubble(
            message: 'Hey, how are you?',
            isMe: true,
            time: '12:00 PM',
          ),
          MessageBubble(
            message: 'Hey, how are you?',
            isMe: false,
            time: '12:00 PM',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          MessageBubble(
            message: 'Hey, how are you?',
            isMe: true,
            time: '12:00 PM',
          ),
          MessageBubble(
            message: 'Hey, how are you?',
            isMe: false,
            time: '12:00 PM',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          MessageBubble(
            message: 'Hey, how are you?',
            isMe: true,
            time: '12:00 PM',
          ),
        ],
      ),
    );
  }
}
