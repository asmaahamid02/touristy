import 'package:flutter/material.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: NetworkImage(
                'https://picsum.photos/200/${200 + index}',
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
