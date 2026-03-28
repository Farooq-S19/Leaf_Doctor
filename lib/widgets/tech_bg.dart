import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/constants.dart';

class TechBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();

    return Stack(
      children: [
        // Light background
        Container(color: AppColors.lightBg),
        
        // Breathing Grid
        AnimatedBuilder(
          animation: AlwaysStoppedAnimation(DateTime.now().millisecondsSinceEpoch),
          builder: (_, __) {
            return CustomPaint(
              size: Size.infinite,
              painter: BreathingGridPainter(),
            );
          },
        ),

        // SINGLE LAYER - Black leaves, larger, slower, lower opacity
        ...List.generate(30, (index) {
          return _leafParticle(
            width: width,
            height: height,
            random: random,
            sizeMin: 15,        // Increased minimum size
            sizeMax: 40,         // Increased maximum size
            opacity: 0.15,        // Decreased opacity (more transparent)
            blur: 1,
            speed: 60,            // Slower movement (higher number)
            swayAmount: 6,
          );
        }),
      ],
    );
  }

  Widget _leafParticle({
    required double width,
    required double height,
    required Random random,
    required double sizeMin,
    required double sizeMax,
    required double opacity,
    required double blur,
    required int speed,
    required double swayAmount,
  }) {
    final icons = [LucideIcons.leaf, LucideIcons.sprout, LucideIcons.treePine];
    
    // Black color with opacity
    final color = Colors.black.withOpacity(opacity);

    return Positioned(
      left: random.nextDouble() * width,
      top: random.nextDouble() * height,
      child: ImageFiltered(
        imageFilter: blur > 0
            ? ImageFilter.blur(sigmaX: blur, sigmaY: blur)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Icon(
          icons[random.nextInt(3)],
          color: color,
          size: sizeMin + random.nextInt((sizeMax - sizeMin).toInt()),
        )
            .animate(onPlay: (c) => c.repeat())
            .move(
              begin: Offset(
                -100 + random.nextDouble() * 100,
                -100 + random.nextDouble() * 100,
              ),
              end: Offset(
                width + random.nextDouble() * 200,
                height + random.nextDouble() * 200,
              ),
              curve: Curves.easeInOut,
              duration: (speed + random.nextInt(15)).seconds,
            )
            .shake(
              hz: 0.08,          // Slower shake
              offset: Offset(swayAmount, 0),
              curve: Curves.easeInOut,
            )
            .rotate(
              begin: 0,
              end: pi * 2,
              duration: (speed + random.nextInt(10)).seconds,
            ),
      ),
    );
  }
}

class BreathingGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double pulse = (sin(DateTime.now().millisecondsSinceEpoch / 800) + 1) / 2;
    double opacity = 0.1 + pulse * 0.05;
    
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..strokeWidth = 0.8;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}