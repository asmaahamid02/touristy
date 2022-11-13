import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/models.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});
  static const String routeName = '/messaging';

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? currentUserId;
  List<int> friendsIds = [];
  bool _isInit = true;
  bool _isLoading = false;

  List<User> randomUsers = [];
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //fetch users from provider
    if (_isInit) {
      try {
        currentUserId = Provider.of<Auth>(context, listen: false).userId;

        setState(() {
          _isLoading = true;
        });
        await Provider.of<Users>(context, listen: false).fetchAndSetUsers();

        //get random users limit 20
        setState(() {
          randomUsers =
              Provider.of<Users>(context, listen: false).getRandomUsers(20);
        });
        for (var element in randomUsers) {
          print(element.id);
        }
      } catch (error) {
        //show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context).users;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('chatUsers', arrayContains: currentUserId)
                  .orderBy('latestMessage.sentAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: CustomScrollView(
                    slivers: [
                      //search bar
                      SliverToBoxAdapter(
                        child: SearchBar(
                          searchController: _searchController,
                        ),
                      ),
                      //stories
                      SliverToBoxAdapter(
                        child: Stories(
                          storiesData: randomUsers
                              .map(
                                (user) => StoryData(
                                  id: user.id,
                                  name: '${user.firstName} ${user.lastName}',
                                  countryCode: user.countryCode,
                                  url: user.profilePictureUrl,
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        sliver: SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            final User user = users.firstWhere((user) =>
                                user.id ==
                                data['chatUsers'].firstWhere(
                                    (element) => element != currentUserId));
                            return _buildMessageTile(
                              MessageData(
                                isRead: data['latestMessage']['isRead'],
                                senderId: user.id,
                                lastMessageSenderId: data['latestMessage']
                                    ['sentBy'],
                                profilePicture: user.profilePictureUrl ?? '',
                                message: data['latestMessage']['text'],
                                messageDate:
                                    data['latestMessage']['sentAt'].toDate(),
                                dateMessage: timeago.format(
                                    data['latestMessage']['sentAt'].toDate()),
                                senderName:
                                    '${user.firstName} ${user.lastName}',
                              ),
                            );

                            // }).toList();
                          }, childCount: snapshot.data!.docs.length),
                        ),
                      )
                    ],
                  ),
                );
              }),
    );
  }

  Widget _buildMessageTile(MessageData messageData) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 1.0),
      child: MessageTile(messageData: messageData),
    );
  }
}
