import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../models/disease_model.dart';
import '../models/scan_model.dart';
import '../data/disease_data.dart';
import '../services/storage_service.dart';

class AnalysisResultScreen extends StatelessWidget {
  final dynamic imageFile;
  final Map<String, dynamic> predictionResult;

  const AnalysisResultScreen({
    super.key,
    required this.imageFile,
    required this.predictionResult,
  });

  Future<void> _saveResult(BuildContext context) async {
    try {
      if (predictionResult['diseaseName'] == 'No Leaf Detected' || 
          predictionResult['diseaseName'] == 'Analysis Error') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot save invalid image analysis'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final scan = ScanResult(
        id: const Uuid().v4(),
        plantName: 'Tomato',
        healthStatus: predictionResult['diseaseName'] ?? 'Unknown',
        confidence: predictionResult['confidence'] ?? 0.0,
        date: DateTime.now().toString().split(' ')[0],
        imagePath: imageFile is File ? imageFile.path : imageFile.toString(),
      );
      
      await StorageService().saveScan(scan);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Result saved successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareResult(BuildContext context) async {
    try {
      final diseaseName = predictionResult['diseaseName'] as String? ?? 'Unknown';
      final confidence = predictionResult['confidence'] as double? ?? 0.0;
      final isLowConfidence = predictionResult['lowConfidenceWarning'] == true;
      
      String shareText = "LeafDoctor AI Analysis Results\n\n";
      
      if (diseaseName == 'No Leaf Detected') {
        shareText += "No Leaf Detected\n";
        shareText += "${predictionResult['message']}\n\n";
      } else if (diseaseName == 'Analysis Error') {
        shareText += " Analysis Failed\n";
        shareText += "${predictionResult['message']}\n\n";
      } else {
        shareText += " Plant: Tomato\n";
        shareText += " Disease: $diseaseName\n";
        shareText += "Confidence: ${confidence.toStringAsFixed(1)}%\n";
        if (isLowConfidence) {
          shareText += "\n⚠️ Low Confidence Warning\n";
          shareText += "${predictionResult['message']}\n";
        }
        shareText += "Date: ${DateTime.now().toString().split(' ')[0]}\n\n";
      }
      
      shareText += "Download LeafDoctor AI for accurate plant disease detection!";
      
      if (imageFile is File && await (imageFile as File).exists()) {
        await Share.shareXFiles([XFile(imageFile.path)], text: shareText);
      } else {
        await Share.share(shareText);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
Widget build(BuildContext context) {
  final diseaseName = predictionResult['diseaseName'] as String? ?? 'Unknown';
  
  // Case 1: No Leaf Detected
  if (diseaseName == 'No Leaf Detected') {
    return _buildMessageScreen(
      context,
      icon: LucideIcons.image,
      title: "No Leaf Detected",
      message: predictionResult['message'] ?? 'No leaf detected in the image.',
      color: Colors.orange,
    );
  }
  
  // NEW CASE: Unable to Identify (low confidence)
  if (diseaseName == 'Unable to Identify') {
    return _buildMessageScreen(
      context,
      icon: LucideIcons.helpCircle,
      title: "Unable to Identify",
      message: predictionResult['message'] ?? 'Unable to confidently identify the disease.',
      color: Colors.orange,
    );
  }
  
  // Case 2: Analysis Error
  if (diseaseName == 'Analysis Error') {
    return _buildMessageScreen(
      context,
      icon: LucideIcons.alertTriangle,
      title: "Analysis Failed",
      message: predictionResult['message'] ?? 'An error occurred during analysis.',
      color: Colors.red,
    );
  }
  
  // Normal case: Show disease result
  return _buildResultScreen(context);
}

  Widget _buildMessageScreen(BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFile is File)
                  Container(
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(imageFile as File),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Icon(icon, size: 80, color: color),
                const SizedBox(height: 20),
                Text(
                  title, 
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24, 
                    fontWeight: FontWeight.w900, 
                    color: AppColors.lightTextPrimary
                  )
                ),
                const SizedBox(height: 10),
                Text(
                  message, 
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, 
                    color: AppColors.lightTextSecondary
                  )
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.arrowLeft),
                      label: const Text("Try Again"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => _shareResult(context),
                      icon: Icon(LucideIcons.share2, color: AppColors.lightTextPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context) {
    final diseaseName = predictionResult['diseaseName'] as String? ?? 'Unknown';
    final confidence = predictionResult['confidence'] as double? ?? 0.0;
    final isHealthy = predictionResult['isHealthy'] as bool? ?? false;
    final isLowConfidence = predictionResult['lowConfidenceWarning'] == true;
    
    // Find matching disease in database
    final disease = diseases.firstWhere(
      (d) => d.name.contains(diseaseName) || diseaseName.contains(d.name),
      orElse: () => diseases.first,
    );
    
    final typeColor = getTypeColor(disease.type);

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(LucideIcons.arrowLeft, color: AppColors.lightTextPrimary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Analysis Result", 
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20, 
                        fontWeight: FontWeight.w700, 
                        color: AppColors.lightTextPrimary
                      )
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _saveResult(context), 
                      icon: Icon(LucideIcons.save, color: AppColors.emerald)
                    ),
                    IconButton(
                      onPressed: () => _shareResult(context), 
                      icon: Icon(LucideIcons.share2, color: AppColors.lightTextPrimary)
                    ),
                  ],
                ),
              ),
              
              // Image with confidence badge
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), 
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imageFile is File
                          ? Image.file(imageFile as File, fit: BoxFit.cover)
                          : Image.network(imageFile.toString(), fit: BoxFit.cover),
                    ),
                  ),
                  
                  // Confidence badge
                  Positioned(
                    top: 20,
                    right: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified, 
                            size: 16, 
                            color: confidence > 90 
                                ? Colors.green 
                                : confidence > 70 
                                    ? Colors.orange 
                                    : Colors.red
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${confidence.toStringAsFixed(1)}% Match",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Disease info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detected Condition",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.lightTextSecondary
                      )
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isHealthy ? "Healthy Plant" : disease.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.lightTextPrimary
                            )
                          ),
                        ),
                        if (!isHealthy)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: typeColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              disease.type,
                              style: TextStyle(
                                color: typeColor,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                      ],
                    ),
                    
                    // LOW CONFIDENCE WARNING SECTION
                    if (isLowConfidence)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(LucideIcons.alertTriangle, color: Colors.orange, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "⚠️ Low Confidence Detection",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                predictionResult['message'] ?? 
                                'Low confidence detection. Please visit a plant testing center.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.lightTextSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Low confidence fallback (if message not set)
                    if (confidence < 70 && !isLowConfidence)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.alertTriangle, size: 16, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Low confidence (${confidence.toStringAsFixed(1)}%). Try with a clearer image.",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.orange
                                  )
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons for disease details
              if (!isHealthy)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          icon: LucideIcons.info,
                          label: "Details",
                          color: Colors.blue,
                          onTap: () => Navigator.pushNamed(
                            context, 
                            '/disease-detail', 
                            arguments: disease
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionCard(
                          icon: LucideIcons.activity,
                          label: "Treatment",
                          color: Colors.green,
                          onTap: () => _showTreatment(context, disease),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Disease description
              if (!isHealthy) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x1A000000)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About ${disease.name}",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary
                          )
                        ),
                        const SizedBox(height: 12),
                        Text(
                          disease.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.lightTextSecondary,
                            height: 1.6
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Symptoms
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x1A000000)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Common Symptoms",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary
                          )
                        ),
                        const SizedBox(height: 12),
                        ...disease.symptoms.map((symptom) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.circle, size: 6, color: typeColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  symptom,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.lightTextSecondary
                                  )
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 30),
              
              // New scan button
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, '/analyzer');
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.emerald, AppColors.emerald.withOpacity(0.7)]
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.camera, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "New Scan",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: onTap == null 
                ? Colors.grey.withOpacity(0.1) 
                : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onTap == null 
                  ? Colors.grey.withOpacity(0.2) 
                  : color.withOpacity(0.3)
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: onTap == null ? Colors.grey : color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: onTap == null ? Colors.grey : AppColors.lightTextPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTreatment(BuildContext context, DiseaseModel disease) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x1A000000),
                borderRadius: BorderRadius.circular(2)
              )
            ),
            const SizedBox(height: 20),
            Text(
              "Treatment & Prevention",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary
              )
            ),
            const SizedBox(height: 16),
            Text(
              disease.treatment,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.lightTextSecondary,
                height: 1.6
              )
            ),
            const SizedBox(height: 20),
            Text(
              "Prevention Tips",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextPrimary
              )
            ),
            const SizedBox(height: 8),
            ...disease.preventionTips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(LucideIcons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.lightTextSecondary
                      )
                    )
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}