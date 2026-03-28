import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/disease_model.dart';
import '../core/constants.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = getTypeColor(disease.type);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppColors.lightBg,
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Image.asset(
              disease.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightSecondaryBg,
                  child: Center(
                    child: Icon(
                      LucideIcons.image,
                      size: 80,
                      color: AppColors.emerald.withOpacity(0.3),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                          Colors.black,
                        ]
                      : [
                          Colors.transparent,
                          AppColors.lightSurface.withOpacity(0.9),
                          AppColors.lightBg,
                        ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          LucideIcons.arrowLeft,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: -0.2),

                  const SizedBox(height: 12),

                  // Disease name and type
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.white.withOpacity(0.1)
                          : AppColors.lightSurface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark 
                            ? Colors.white24 
                            : const Color(0x1A000000),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease.scientificName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.emerald,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          disease.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: typeColor.withOpacity(isDark ? 0.3 : 0.2),
                            ),
                          ),
                          child: Text(
                            disease.type,
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  // Description section
                  _buildSection(
                    context: context,
                    title: "Description",
                    icon: LucideIcons.info,
                    content: disease.description,
                    isDark: isDark,
                    delay: 400,
                  ),

                  const SizedBox(height: 12),

                  // Symptoms section
                  _buildSection(
                    context: context,
                    title: "Symptoms",
                    icon: LucideIcons.alertTriangle,
                    content: disease.symptoms.map((s) => "• $s").join('\n'),
                    isDark: isDark,
                    delay: 600,
                  ),

                  const SizedBox(height: 12),

                  // Treatment section (ONLY TREATMENT, NO PRECAUTIONS)
                  _buildSection(
                    context: context,
                    title: "Treatment",
                    icon: LucideIcons.activity,
                    content: disease.treatment,
                    isDark: isDark,
                    delay: 800,
                  ),

                  // PREVENTION SECTION REMOVED - Only treatment shown

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String content,
    required bool isDark,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : AppColors.lightSurface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white24 
              : const Color(0x1A000000),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.emerald, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }
}