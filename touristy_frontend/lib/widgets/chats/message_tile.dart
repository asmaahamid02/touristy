import 'package:flutter/material.dart';
import '../../screens/screens.dart';
import '../../utilities/utilities.dart';
import '../../models/models.dart';
import '../widgets.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ChatScreen.routeName,
        arguments: messageData,
      ),
      child: Row(
        children: [
          _buildAvatar(context, messageData.profilePicture),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUsername(messageData.senderName),
                _buildLastMessage(messageData.message),
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
                _buildMessageDate(messageData.dateMessage),
                const SizedBox(height: 5.0),
                _buildMoreIcon(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildMoreIcon() {
    return Container(
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

  SizedBox _buildLastMessage(String message) {
    return SizedBox(
        height: 20.0,
        child: Text(
          message,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.0, color: AppColors.textFaded),
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

  Padding _buildAvatar(BuildContext context, String profilePicture) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Avatar.medium(imageUrl: profilePicture),
    );
  }
}
