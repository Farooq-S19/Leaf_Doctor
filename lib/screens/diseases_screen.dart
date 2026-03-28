import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/disease_data.dart';
import '../models/disease_model.dart';
import '../core/constants.dart';
import 'disease_detail_screen.dart';

class DiseasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disease Database",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.emerald.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final d = diseases[index];
          return DiseaseCard(disease: d, index: index);
        },
      ),
    );
  }
}

class DiseaseCard extends StatefulWidget {
  final DiseaseModel disease;
  final int index;

  const DiseaseCard({super.key, required this.disease, required this.index});

  @override
  State<DiseaseCard> createState() => _DiseaseCardState();
}

class _DiseaseCardState extends State<DiseaseCard> {
  bool isExpanded = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = getTypeColor(widget.disease.type);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiseaseDetailScreen(disease: widget.disease),
          ),
        );
      },
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.lightSurface,
                        AppColors.lightSecondaryBg,
                      ]
                    : [
                        AppColors.lightSurface,
                        AppColors.lightSecondaryBg,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: typeColor.withOpacity(isDark ? 0.2 : 0.15),
                  blurRadius: isExpanded ? 20 : 10,
                  spreadRadius: isExpanded ? 5 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: typeColor.withOpacity(isDark ? 0.3 : 0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  // Image section with overlay
                  Stack(
                    children: [
                      Image.asset(
                        widget.disease.image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: AppColors.lightSecondaryBg,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: AppColors.emerald.withOpacity(0.3),
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isDark
                                  ? [
                                      Colors.transparent,
                                      AppColors.lightSecondaryBg,
                                    ]
                                  : [
                                      Colors.transparent,
                                      AppColors.lightSurface,
                                    ],
                            ),
                          ),
                        ),
                      ),
                      // Type badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: TweenAnimationBuilder<double>(
                          duration: 300.ms,
                          tween: Tween(begin: 0.8, end: 1.0),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: typeColor.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.disease.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Disease name at bottom of image
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Text(
                          widget.disease.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scientific name
                        Text(
                          widget.disease.scientificName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.emerald,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Description
                        AnimatedCrossFade(
                          duration: 300.ms,
                          firstChild: Text(
                            widget.disease.shortDescription,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
                              height: 1.5,
                            ),
                          ),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.disease.description,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Symptoms
                              Text(
                                "Symptoms:",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...widget.disease.symptoms.map((symptom) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 6,
                                      color: typeColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        symptom,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          color: isDark ? Colors.white60 : AppColors.lightTextTertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          crossFadeState: isExpanded 
                              ? CrossFadeState.showSecond 
                              : CrossFadeState.showFirst,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Treatment button
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.medical_services,
                                label: "Treatment",
                                typeColor: typeColor,
                                isDark: isDark,
                                onTap: () {
                                  _showTreatmentDialog(context, typeColor, isDark);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Details button
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.info_outline,
                                label: "Details",
                                typeColor: typeColor,
                                isDark: isDark,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DiseaseDetailScreen(disease: widget.disease),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Expand indicator
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() => isExpanded = !isExpanded);
                            },
                            icon: AnimatedRotation(
                              duration: 300.ms,
                              turns: isExpanded ? 0.5 : 0,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: typeColor,
                              ),
                            ),
                            label: Text(
                              isExpanded ? "Show less" : "Show more",
                              style: TextStyle(
                                color: typeColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate()
        .fadeIn(duration: 400.ms, delay: (widget.index * 100).ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color typeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                typeColor.withOpacity(isDark ? 0.2 : 0.1),
                typeColor.withOpacity(isDark ? 0.1 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: typeColor.withOpacity(isDark ? 0.3 : 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: typeColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ).animate().scale(
          duration: 200.ms,
          curve: Curves.elasticOut,
        ),
      ),
    );
  }

  void _showTreatmentDialog(BuildContext context, Color typeColor, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          duration: 400.ms,
          tween: Tween(begin: 0, end: 1),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.lightSurface,
                            AppColors.lightSecondaryBg,
                          ]
                        : [
                            AppColors.lightSurface,
                            AppColors.lightSecondaryBg,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: typeColor.withOpacity(isDark ? 0.3 : 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: typeColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Treatment",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.disease.treatment,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: AppColors.lightTextSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: typeColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}