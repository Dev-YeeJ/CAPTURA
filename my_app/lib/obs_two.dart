import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_screen.dart'; // Import ObsTwo

class ObsTwo extends StatelessWidget {
  const ObsTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A4D9C), // Top color
              Color(0xFF0C1C2E), // Bottom color
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: () {
                        // Handle skip action
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Single centered image
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/obstwo.png',
                        width: 280,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 280,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_outlined,
                                color: Colors.white.withOpacity(0.8),
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Main heading text
                Text(
                  'Everything You Need',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 16),

                // Description text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'From weddings to corporate events, we deliver\nprofessional results every time',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Feature cards
                _buildFeatureCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Easy Booking',
                  subtitle:
                      'Schedule your sessions easily with just a few taps',
                ),

                const SizedBox(height: 10),

                _buildFeatureCard(
                  icon: Icons.groups_outlined,
                  title: 'Expert Team',
                  subtitle: 'Professional photographers and videographers',
                ),

                const SizedBox(height: 10),

                _buildFeatureCard(
                  icon: Icons.verified_outlined,
                  title: 'Quality Guaranteed',
                  subtitle: '10+ years of experience with 500+ happy clients',
                ),

                const Spacer(),

                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Get Started button
                Container(
                  width: double.infinity,
                  height: 52,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A4D9C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
