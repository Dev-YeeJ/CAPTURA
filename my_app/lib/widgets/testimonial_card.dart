// widgets/testimonial_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialCard extends StatelessWidget {
  final String name;
  final String initials;
  final String testimonial;
  final String badge;

  const TestimonialCard({
    Key? key,
    required this.name,
    required this.initials,
    required this.testimonial,
    required this.badge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1A4D9C).withOpacity(0.1),
                child: Text(
                  initials,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A4D9C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$testimonial"',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A4D9C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF1A4D9C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
