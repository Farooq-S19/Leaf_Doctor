import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color emerald = Color(0xFF059669);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color glass = Colors.white70;

  static TextStyle mono(double size, Color color, {bool bold = false}) => 
    GoogleFonts.jetBrainsMono(fontSize: size, color: color, fontWeight: bold ? FontWeight.bold : FontWeight.normal);

  static TextStyle sans(double size, Color color, {FontWeight weight = FontWeight.normal}) => 
    GoogleFonts.plusJakartaSans(fontSize: size, color: color, fontWeight: weight);
}