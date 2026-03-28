import 'package:flutter/material.dart';

class GridBackground extends StatefulWidget {
  @override
  _GridBackgroundState createState() => _GridBackgroundState();
}

class _GridBackgroundState extends State<GridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // smooth infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            Container(color: const Color(0xFFF8FAFC)),
            CustomPaint(
              size: Size.infinite,
              painter: AnimatedGridPainter(progress: _controller.value),
            ),
          ],
        );
      },
    );
  }
}

class AnimatedGridPainter extends CustomPainter {
  final double progress;
  AnimatedGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F430B).withOpacity(0.05)
      ..strokeWidth = 0.8;

    const double gap = 40.0;

    // smooth grid shift (top-left → bottom-right)
    final offsetX = progress * gap;
    final offsetY = progress * gap;

    for (double i = -gap; i < size.width + gap; i += gap) {
      canvas.drawLine(
        Offset(i + offsetX, 0),
        Offset(i + offsetX, size.height),
        paint,
      );
    }

    for (double i = -gap; i < size.height + gap; i += gap) {
      canvas.drawLine(
        Offset(0, i + offsetY),
        Offset(size.width, i + offsetY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedGridPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
