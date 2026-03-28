// screens/research_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/app_background.dart';
import '../widgets/metric_counter.dart';
import '../widgets/highlight_quote.dart';
import '../widgets/dev_timeline_step.dart';
import '../core/constants.dart';

class ResearchScreen extends StatelessWidget {
  const ResearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Research Abstract"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Executive Summary",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(begin: -0.2),

              const SizedBox(height: 16),

              Text(
                "Tomato crops are highly susceptible to various leaf diseases that can significantly reduce yield and quality. Traditional disease detection methods rely on expert visual inspection, which is time-consuming and not always accessible to farmers in remote areas.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              HighlightQuote(
                '"To overcome these limitations, this study proposes a deep learning–based automated tomato leaf disease classification system using EfficientNet-B0."',
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 28),

              Text(
                "Model Performance",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 16),

              MetricCounter(
                label: "Accuracy",
                value: 99.69,
                icon: LucideIcons.target,
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 12),

              MetricCounter(
                label: "Precision",
                value: 98.27,
                icon: LucideIcons.checkCircle,
              ).animate().fadeIn(delay: 1000.ms),

              const SizedBox(height: 32),

              Text(
                "EfficientNet-B0 Strategy",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 1200.ms),

              const SizedBox(height: 16),

              DevTimelineStep(
                date: "Oct 2024",
                title: "Phase I: Research",
                desc: "Comprehensive study of Solanum Lycopersicum pathology and existing detection methods.",
                icon: LucideIcons.lightbulb,
              ).animate().fadeIn(delay: 1400.ms),

              const SizedBox(height: 16),

              DevTimelineStep(
                date: "Nov 2024",
                title: "Phase II: Dataset",
                desc: "Collection and preprocessing of 10,000+ tomato leaf images across 9 disease classes.",
                icon: LucideIcons.database,
              ).animate().fadeIn(delay: 1600.ms),

              const SizedBox(height: 16),

              DevTimelineStep(
                date: "Dec 2024",
                title: "Phase III: Neural Network",
                desc: "EfficientNet-B0 integration with transfer learning and hyperparameter optimization.",
                icon: LucideIcons.brain,
              ).animate().fadeIn(delay: 1800.ms),

              const SizedBox(height: 16),

              DevTimelineStep(
                date: "Jan 2025",
                title: "Phase IV: Mobile Deployment",
                desc: "Model compression and optimization for real-time mobile inference.",
                icon: LucideIcons.smartphone,
              ).animate().fadeIn(delay: 2000.ms),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}