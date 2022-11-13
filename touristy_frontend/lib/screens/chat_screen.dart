import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
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

  void _sendMessage(String message) {
    if (chatDocId == null) {
      //create new chat
      chats.add({
        'chatUsers': [userId, messageData!.senderId],
        'latestMessage': {
          'text': message,
          'sentAt': DateTime.now(),
          'sentBy': userId,
          'isRead': false,
          'readAt': null,
        },
      }).then((value) {
        setState(() {
          chatDocId = value.id;
        });
        chats.doc(value.id).collection('messages').add({
          'text': message,
          'sentAt': DateTime.now(),
          'sentBy': userId,
          'isRead': false,
          'readAt': null,
        });
      }).catchError((onError) {});
    } else {
      //update existing chat
      chats.doc(chatDocId).update({
        'latestMessage': {
          'text': message,
          'sentAt': DateTime.now(),
          'sentBy': userId,
          'isRead': false,
          'readAt': null,
        },
      }).then((_) {
        chats.doc(chatDocId).collection('messages').add({
          'text': message,
          'sentAt': DateTime.now(),
          'sentBy': userId,
          'isRead': false,
          'readAt': null,
        });
      }).catchError((onError) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.light ? Theme.of(context).cardColor : null,
      appBar: AppBar(
        title: _AppBarTitle(
          messageData: messageData!,
        ),
        elevation: 1.0,
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
                  MessageInput(sendMessage: _sendMessage),
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
              //group messages by date
              final groupedMessages = _groupMessagesByDate(messages);
              //return messages
              return _buildChatList(groupedMessages, userId, messageData);
            }

            return const Center(
              child: Text('No messages'),
            );
          }),
    ));
  }

  Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _groupMessagesByDate(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> messages) {
    return groupBy(messages, (obj) {
      final date = (obj['sentAt'] as Timestamp).toDate();
      //format date to only show date without time (e.g. Wed, 12 May 2021)
      return DateFormat('EEE, d MMM yyyy').format(date);
    });
  }

  ListView _buildChatList(
      Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
          groupedMessages,
      int? userId,
      MessageData messageData) {
    return ListView.builder(
      reverse: true,
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final date = groupedMessages.keys.elementAt(index);
        final messages = groupedMessages[date]
            as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

        return Column(
          children: [
            ChatDateLabel(label: date),
            const SizedBox(height: 4.0),
            _buildChatListByDate(messages, userId, messageData),
          ],
        );
      },
    );
  }

  ListView _buildChatListByDate(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messages,
      int? userId,
      MessageData messageData) {
    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final messageText = message['text'];
        final messageTime = DateFormat.jm().format(message['sentAt'].toDate());
        final messageSenderId = message['sentBy'];
        final isMe = messageSenderId == userId;

        //update message to read
        if (!isMe && !message['isRead']) {
          _updateMessageReadStatus(messages, index);
        }

        //update latest message to read
        if (!isMe && index == 0 && !message['isRead']) {
          _updateLastMessageReadStatus();
        }

        return MessageBubble(
          message: messageText,
          time: messageTime,
          isMe: isMe,
          avatarUrl: messageData.profilePicture,
        );
      },
    );
  }

  void _updateLastMessageReadStatus() {
    FirebaseFirestore.instance.collection('chats').doc(chatDocId).update({
      'latestMessage.isRead': true,
      'latestMessage.readAt': DateTime.now(),
    });
  }

  void _updateMessageReadStatus(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messages, int index) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .doc(messages[index].id)
        .update({
      'isRead': true,
      'readAt': DateTime.now(),
    });
  }
}
