import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors Only
  static const lightBg = Color(0xFFF7F9FA);
  static const lightSecondaryBg = Color(0xFFEDF1F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBottomSheet = Color(0xFFFAFAFA);
  static const lightSlate600 = Color(0xFF475569);
  
  // Text Colors
  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF4A4A4A);
  static const lightTextTertiary = Color(0xFF6D6D6D);
  static const lightTextDisabled = Color(0xFF9E9E9E);
  
  // Accent Colors
  static const emerald = Color(0xFF10B981);
  static const lightDanger = Color(0xFFE53935);
  static const lightModerate = Color(0xFFFF9800);
  static const lightMild = Color(0xFFF9A825);
  static const lightHealthy = Color(0xFF26D07C);
  
  // Card Styles
  static const lightCardBorder = Color(0x1A000000);
  static const lightCardShadow = Color(0x1A000000);
}

// Helper function for type colors (simplified - no dark mode)
// NO CONTEXT PARAMETER - just takes the type string
Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'dangerous':
      return AppColors.lightDanger;
    case 'moderate':
      return AppColors.lightModerate;
    case 'mild':
      return AppColors.lightMild;
    case 'healthy':
      return AppColors.lightHealthy;
    default:
      return AppColors.emerald;
  }
}