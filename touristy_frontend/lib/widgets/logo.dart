import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo(
    this.path, {
    Key? key,
  }) : super(key: key);

  final String path;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      child: Image.asset(path),
    );
  }
}
