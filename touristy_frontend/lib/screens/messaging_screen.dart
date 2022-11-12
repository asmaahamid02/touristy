import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/models.dart';
import '../widgets/widgets.dart';

class MessagingScreen extends StatelessWidget {
  MessagingScreen({super.key});
  static const String routeName = '/messaging';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: GestureDetector(
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
                storiesData: [
                  StoryData(
                    name: faker.person.name(),
                    url:
                        'https://picsum.photos/200?random=${faker.randomGenerator.integer(70)}',
                  ),
                  StoryData(
                    name: faker.person.name(),
                    url:
                        'https://picsum.photos/200?random=${faker.randomGenerator.integer(70)}',
                  ),
                  StoryData(
                    name: faker.person.name(),
                    url:
                        'https://picsum.photos/200?random=${faker.randomGenerator.integer(70)}',
                  ),
                  StoryData(
                    name: faker.person.name(),
                    url:
                        'https://picsum.photos/200?random=${faker.randomGenerator.integer(70)}',
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(_delegate, childCount: 10
                  // snapshot.data!.docs.length,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _delegate(BuildContext context, int index) {
    final faker = Faker();
    //fake datetime object between 1 and 2 years ago
    final messageDate = faker.date
        .dateTime(minYear: DateTime.now().year, maxYear: DateTime.now().year);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 1.0),
      child: MessageTile(
          messageData: MessageData(
        message: faker.lorem.sentence(),
        senderName: faker.person.name(),
        messageDate: messageDate,
        dateMessage: timeago.format(messageDate),
        //get random image from picsum
        profilePicture: 'https://picsum.photos/200/300?random=$index',
      )),
    );
  }
}
