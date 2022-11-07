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
            ],
          ),
        ),
      ),
    );
  }
}
