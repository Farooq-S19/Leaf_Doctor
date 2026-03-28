// widgets/metric_counter.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class MetricCounter extends StatefulWidget {
  final String label;
  final double value;
  final IconData icon;

  const MetricCounter({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  State<MetricCounter> createState() => _MetricCounterState();
}

class _MetricCounterState extends State<MetricCounter> {
  double animatedValue = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(100.ms, () {
      if (mounted) {
        setState(() {
          animatedValue = widget.value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: AppColors.emerald, size: 24),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          TweenAnimationBuilder<double>(
            duration: 2000.ms,
            tween: Tween(begin: 0, end: widget.value),
            builder: (context, value, child) {
              return Text(
                "${value.toStringAsFixed(2)}%",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightTextPrimary,
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}