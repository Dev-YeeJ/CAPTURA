// widgets/stat_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1A4D9C), size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
