// widgets/scanner_animation.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';

class ScannerAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        // Scanning line
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.emerald.withOpacity(0.8),
                  AppColors.emerald,
                  AppColors.emerald.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emerald.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).moveY(
            begin: 0,
            end: size.height * 0.7,
            duration: 2500.ms,
            curve: Curves.easeInOut,
          ),
        ),

        // Scanning dots
        ...List.generate(20, (index) {
          return Positioned(
            left: (index * 30).toDouble(),
            top: (index * 20).toDouble(),
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.emerald.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ],
    );
  }
}