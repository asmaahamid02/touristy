import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/profile_avatar.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});
  static const routeName = '/new-post';
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text('New Post'),
      leading: TextButton(
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      leadingWidth: 80,
      actions: [
        Container(
          margin: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor)),
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _PostHeader(),
              Expanded(
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                            hintText: "Type a memory..."),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
  }) : super(key: key);

  DropdownMenuItem<String> _buildDropdownMenuItem(
      BuildContext context, String value, IconData icon) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(value.toLowerCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          const ProfileAvatar(
            imageUrl: 'https://picsum.photos/200',
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 15,
                      color: Colors.white,
                    ),
                    items: [
                      _buildDropdownMenuItem(context, 'Public', Icons.public),
                      _buildDropdownMenuItem(context, 'Friends', Icons.people),
                    ],
                    dropdownColor: Theme.of(context).primaryColor,
                    value: 'Public',
                    onChanged: (value) {
                      print(value);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
