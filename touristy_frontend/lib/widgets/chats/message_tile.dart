import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/screens.dart';
import '../../utilities/utilities.dart';
import '../../models/models.dart';
import '../widgets.dart';
import '../../providers/providers.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ChatScreen.routeName,
        arguments: messageData,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildAvatar(messageData.profilePicture),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUsername(messageData.senderName),
                    _buildLastMessage(
                        messageData.message!,
                        messageData.isRead ?? false,
                        messageData.lastMessageSenderId == userId),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4.0,
                    ),
                    _buildMessageDate(messageData.dateMessage!),
                    const SizedBox(height: 5.0),
                    _buildIcons(messageData.isRead ?? false,
                        messageData.lastMessageSenderId == userId),
                  ],
                ),
              )
            ],
          ),
          const Divider(thickness: 0.5)
        ],
      ),
    );
  }

  Widget _buildIcons(bool isRead, bool isCurrentUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isRead && !isCurrentUser)
          Container(
            height: 10.0,
            width: 10.0,
            margin: const EdgeInsets.only(right: 5.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary,
            ),
          ),
        Container(
          height: 18.0,
          width: 18.0,
          margin: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: AppColors.secondary,
            ),
            iconSize: 18.0,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Text _buildMessageDate(String dateMessage) {
    return Text(
      dateMessage,
      style: const TextStyle(
        color: AppColors.textFaded,
        fontSize: 11.0,
        letterSpacing: -0.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  SizedBox _buildLastMessage(String message, bool isRead, bool isCurrentUser) {
    return SizedBox(
        height: 20.0,
        child: Text(
          isCurrentUser ? 'You: $message' : message,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 12.0,
              color: !isCurrentUser
                  ? isRead
                      ? AppColors.textFaded
                      : AppColors.secondary
                  : AppColors.textFaded,
              fontWeight: FontWeight.w600),
        ));
  }

  Padding _buildUsername(String username) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(username,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              letterSpacing: 0.2,
              fontWeight: FontWeight.bold,
              wordSpacing: 1.5)),
    );
  }

  Padding _buildAvatar(String? profilePicture) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Avatar.medium(imageUrl: profilePicture),
    );
  }
}
