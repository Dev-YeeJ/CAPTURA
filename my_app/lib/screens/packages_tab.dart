// screens/packages_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/package_card_full.dart';

class PackagesTab extends StatelessWidget {
  const PackagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Packages',
          style: GoogleFonts.inter(
            color: const Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your Package',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Professional photography and videography services',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const PackageCardFull(
              title: 'Premium Wedding Package',
              price: '₱45,000',
              description: 'Complete wedding coverage with premium features',
              features: [
                '10 hour coverage',
                'Full Team of Videographers',
                '3 Videographers',
                'Cinematic Highlight Film',
                '2 Subcontractors',
                'Drone Coverage',
              ],
              isPopular: true,
            ),
            const SizedBox(height: 16),
            const PackageCardFull(
              title: 'Standard Wedding Package',
              price: '₱28,000',
              description: 'Essential wedding coverage for your special day',
              features: [
                '6 hour coverage',
                '2 Videographers',
                'Highlight Film',
                'Professional Editing',
                'Digital Download',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 16),
            const PackageCardFull(
              title: 'Product Shoot Package',
              price: '₱12,000',
              description: 'Professional product photography for businesses',
              features: [
                '7-day shoot',
                'Studio setup',
                'Professional Product Shots',
                'Edited Images',
                'Social Media Ready',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
