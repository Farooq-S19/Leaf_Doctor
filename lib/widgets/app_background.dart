import 'package:flutter/material.dart';
import 'tech_bg.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TechBackground(), // background everywhere
        child,                  // your page content
      ],
    );
  }
}
