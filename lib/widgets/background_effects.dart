import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/constants.dart';

class BlowingLeaves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(15, (index) {
        return Positioned(
          left: (index * 60).toDouble() - 50,
          top: (index * 120).toDouble() - 50,
          child: Icon(LucideIcons.leaf, color: AppColors.emerald.withOpacity(0.2), size: 40)
              .animate(onPlay: (c) => c.repeat())
              .move(begin: const Offset(-100, -100), end: const Offset(600, 800), duration: (15 + index).seconds)
              .rotate(begin: 0, end: 5),
        );
      }),
    );
  }
}