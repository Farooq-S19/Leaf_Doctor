import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_card.dart';  // correct path
import '../core/constants.dart';      // your AppColors

class DevTimelineStep extends StatelessWidget {
  final String date;
  final String title;
  final String desc;
  final IconData icon;

  const DevTimelineStep({
    required this.date,
    required this.title,
    required this.desc,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: AppColors.emerald),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
