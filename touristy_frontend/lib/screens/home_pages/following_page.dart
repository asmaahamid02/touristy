import 'package:flutter/material.dart';
import '../../widgets/posts/post_list.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [PostsList()],
    );
  }
}
