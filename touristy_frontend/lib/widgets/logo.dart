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

class LogoHorizontal extends StatelessWidget {
  const LogoHorizontal(
    this.path,
    this.height, {
    Key? key,
  }) : super(key: key);

  final String path;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Image.asset(path),
    );
  }
}
