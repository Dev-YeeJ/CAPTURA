import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/package_card_full.dart';
import '../auth_service.dart';
import '../database_helper.dart';
import '../sign_in_screen.dart';
import '../widgets/booking_bottom_sheet.dart'; // Ensure this file exists!

class PackagesTab extends StatelessWidget {
  const PackagesTab({Key? key}) : super(key: key);

  // Function to handle booking logic
  Future<void> _handleBooking(
    BuildContext context,
    String title,
    String price,
  ) async {
    // 1. Check if user is logged in
    final user = AuthService.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to book a package')),
      );
      // Redirect to login logic here or just return
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
      return;
    }

    // 2. Show the Advanced Booking Bottom Sheet
    final bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Important for keyboard to work
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingBottomSheet(
        userId: user['user_id'],
        packageTitle: title,
        price: price,
      ),
    );

    // 3. Handle Result
    if (result == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking Successful! Check your profile.'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

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
            PackageCardFull(
              title: 'Premium Wedding Package',
              price: '₱45,000',
              description: 'Complete wedding coverage with premium features',
              features: const [
                '10 hour coverage',
                'Full Team of Videographers',
                '3 Videographers',
                'Cinematic Highlight Film',
                'Drone Coverage',
              ],
              isPopular: true,
              onBookPressed: () =>
                  _handleBooking(context, 'Premium Wedding Package', '45000'),
            ),
            const SizedBox(height: 16),
            PackageCardFull(
              title: 'Standard Wedding Package',
              price: '₱28,000',
              description: 'Essential wedding coverage for your special day',
              features: const [
                '6 hour coverage',
                '2 Videographers',
                'Highlight Film',
                'Professional Editing',
                'Digital Download',
              ],
              isPopular: false,
              onBookPressed: () =>
                  _handleBooking(context, 'Standard Wedding Package', '28000'),
            ),
            const SizedBox(height: 16),
            PackageCardFull(
              title: 'Product Shoot Package',
              price: '₱12,000',
              description: 'Professional product photography for businesses',
              features: const [
                '7-day shoot',
                'Studio setup',
                'Professional Product Shots',
                'Edited Images',
                'Social Media Ready',
              ],
              isPopular: false,
              onBookPressed: () =>
                  _handleBooking(context, 'Product Shoot Package', '12000'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
