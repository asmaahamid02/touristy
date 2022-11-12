import 'package:flutter/material.dart';
import '../utilities/utilities.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    final messageData =
        ModalRoute.of(context)!.settings.arguments as MessageData;
    return Scaffold(
      appBar: AppBar(
        title: _AppBarTitle(
          messageData: messageData,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: const [
            Expanded(child: MessageList()),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.messageData, Key? key}) : super(key: key);
  final MessageData messageData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Avatar.small(imageUrl: 'https://picsum.photos/200'),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                messageData.senderName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 2.0),
              Row(
                children: const [
                  Icon(
                    Icons.location_on,
                    size: 10.0,
                    color: Colors.red,
                  ),
                  SizedBox(width: 2.0),
                  Text('London, UK',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.textFaded,
                      )),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
