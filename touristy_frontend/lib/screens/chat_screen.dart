import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utilities/utilities.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CollectionReference chats =
      FirebaseFirestore.instance.collection('chats');

  MessageData? messageData;
  int? userId;
  String? chatDocId;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      messageData = ModalRoute.of(context)!.settings.arguments as MessageData;
      userId = Provider.of<Auth>(context, listen: false).userId;
      setState(() {
        _isLoading = true;
      });

      await chats
          .where('chatUsers', whereIn: [
            [userId, messageData!.senderId],
            [messageData!.senderId, userId]
          ])
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              chatDocId = querySnapshot.docs.single.id;
            } else {
              chatDocId = null;
            }
          })
          .catchError((onError) {});

      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _AppBarTitle(
          messageData: messageData!,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  _ChatMessages(chatDocId: chatDocId),
                ],
              )),
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
          Avatar.small(imageUrl: messageData.profilePicture),
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

class _ChatMessages extends StatelessWidget {
  const _ChatMessages({Key? key, this.chatDocId}) : super(key: key);
  final String? chatDocId;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final messageData =
        ModalRoute.of(context)!.settings.arguments as MessageData;

    print(chatDocId);
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .orderBy('sentAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final messages = snapshot.data!.docs;
              print('messages: $messages');

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index].data();

                  final messageText = message['text'];
                  final messageTime =
                      DateFormat.jm().format(message['sentAt'].toDate());
                  final messageSenderId = message['sentBy'];
                  final isMe = messageSenderId == userId;

                  return MessageBubble(
                    message: messageText,
                    time: messageTime,
                    isMe: isMe,
                    avatarUrl: messageData.profilePicture,
                  );
                },
              );
            }

            return const Center(
              child: Text('No messages'),
            );
          }),
    ));
  }
}
