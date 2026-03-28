import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
class HighlightQuote extends StatelessWidget {
  final String text;
  const HighlightQuote(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Colors.greenAccent, width: 4),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
