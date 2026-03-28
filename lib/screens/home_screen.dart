import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/constants.dart';
import '../widgets/tech_bg.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TechBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _header(),
                  const Spacer(),
                  _heroText(),
                  const SizedBox(height: 60),
                  _mainButton(context),
                  const SizedBox(height: 16),
                  _gridActions(context),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Icon(LucideIcons.leaf, color: AppColors.emerald),
        const SizedBox(width: 8),
        Text(
          "Leaf Doctor", 
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900, 
            fontSize: 18,
            color: AppColors.lightTextPrimary,
          )
        ),
      ],
    );
  }

  Widget _heroText() {
    return Column(
      children: [
        Text(
          "Tomato Leaf\nDisease\nDetector", 
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 45, 
            fontWeight: FontWeight.w900, 
            height: 0.90, 
            letterSpacing: -2,
            color: AppColors.lightTextPrimary,
          )
        ),
      ],
    );
  }

  Widget _mainButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/analyzer'),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: const Color(0x1A000000),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scan Leaf", 
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.lightTextPrimary,
                fontSize: 24, 
                fontWeight: FontWeight.w900
              )
            ),
            Icon(
              LucideIcons.chevronRight, 
              color: AppColors.lightTextPrimary, 
              size: 30
            ),
          ],
        ),
      ).animate().scale(curve: Curves.elasticOut),
    );
  }

  Widget _gridActions(BuildContext context) {
    return Row(
      children: [
        _smallBtn(
          LucideIcons.database, 
          "Gallery", 
          () => Navigator.pushNamed(context, '/gallery'),
        ),
        const SizedBox(width: 12),
        _smallBtn(
          LucideIcons.microscope, 
          "Disease Guide", 
          () => Navigator.pushNamed(context, '/diseases'),
        ),
        const SizedBox(width: 12),
        _smallBtn(
          LucideIcons.info, 
          "About", 
          () => Navigator.pushNamed(context, '/about'),
        ),
      ],
    );
  }

  Widget _smallBtn(IconData icon, String label, VoidCallback tap) {
    return Expanded(
      child: InkWell(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(
              color: const Color(0x1A000000),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0A000000),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.lightTextSecondary),
              const SizedBox(height: 8), 
              Text(
                label, 
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextSecondary,
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}