import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LeafParticles extends StatelessWidget {
  final List<IconData> leafIcons = [
    LucideIcons.leaf,
    LucideIcons.sprout,
    LucideIcons.treePine,
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();

    return Stack(
      children: List.generate(20, (index) {
        return Positioned(
          left: random.nextDouble() * width,
          top: random.nextDouble() * height,
          child: Icon(
            leafIcons[random.nextInt(leafIcons.length)],
            color: const Color(0xFF10B981).withOpacity(0.06),
            size: 15.0 + random.nextInt(40),
          )
              .animate(onPlay: (c) => c.repeat())
              .move(
                // start anywhere slightly outside the screen
                begin: Offset(
                  -50 + random.nextDouble() * 50,
                  -50 + random.nextDouble() * 50,
                ),
                // travel beyond bottom-right of screen
                end: Offset(
                  width + random.nextDouble() * 150,
                  height + random.nextDouble() * 150,
                ),
                duration: (15 + random.nextInt(20)).seconds,
              )
              .rotate(begin: 0, end: pi * 2),
        );
      }),
    );
  }
}
