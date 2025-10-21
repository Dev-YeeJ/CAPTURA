// screens/contact_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({Key? key}) : super(key: key);

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+639631638078');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hello@capturastudio.ph',
      query: 'subject=Booking Inquiry',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchMaps() async {
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=123+Photography+Ave,+Makati+City',
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchSocialMedia(String platform) async {
    String url = '';
    switch (platform) {
      case 'instagram':
        url = 'https://instagram.com/capturastudio';
        break;
      case 'facebook':
        url = 'https://facebook.com/capturastudio';
        break;
      case 'tiktok':
        url = 'https://tiktok.com/@capturastudio';
        break;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1A4D9C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Captura Studio',
              style: GoogleFonts.inter(
                color: const Color(0xFF2D3748),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF2D3748),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: const Color(0xFF2D3748),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Get in Touch',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to capture your special\nmoments? Let\'s discuss your vision',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF1A4D9C),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildContactCard(
                    icon: Icons.chat_bubble,
                    iconColor: const Color(0xFF10B981),
                    title: 'Live Chat',
                    subtitle: 'Chat with our team now',
                    badge: 'Online',
                    badgeColor: const Color(0xFF10B981),
                    onTap: () {
                      // Open live chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening live chat...')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: Icons.phone,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Call Us',
                    subtitle: '+63 963 163 8078',
                    badge: '24/7',
                    badgeColor: const Color(0xFF3B82F6),
                    onTap: _launchPhone,
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: Icons.email,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Email Us',
                    subtitle: 'hello@capturastudio.ph',
                    badge: 'Fast Reply',
                    badgeColor: const Color(0xFF8B5CF6),
                    onTap: _launchEmail,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Social Media Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Follow Our Journey',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay updated with our latest work and\nbehind-the-scenes content',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.camera_alt,
                        label: 'Instagram',
                        count: '12.5k',
                        onTap: () => _launchSocialMedia('instagram'),
                      ),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        count: '8.2k',
                        onTap: () => _launchSocialMedia('facebook'),
                      ),
                      _buildSocialButton(
                        icon: Icons.video_library,
                        label: 'TikTok',
                        count: '10.3k',
                        onTap: () => _launchSocialMedia('tiktok'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Visit Studio Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A4D9C), Color(0xFF0C1C2E)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Visit Our Studio',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '123 Photography Ave, Makati City',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _launchMaps,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A4D9C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Get Directions',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Business Hours
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF1A4D9C),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Business Hours',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHoursRow('Monday - Friday', '9:00 AM - 6:00 PM'),
                  const SizedBox(height: 8),
                  _buildHoursRow('Saturday', '10:00 AM - 4:00 PM'),
                  const SizedBox(height: 8),
                  _buildHoursRow('Sunday', 'By Appointment Only'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Inquiry Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Inquiry',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Your Name'),
                  const SizedBox(height: 12),
                  _buildTextField('Email Address'),
                  const SizedBox(height: 12),
                  _buildTextField('Phone Number'),
                  const SizedBox(height: 12),
                  _buildDropdownField('Service Type', [
                    'Wedding Photography',
                    'Wedding Videography',
                    'Portrait Session',
                    'Product Photography',
                    'Event Coverage',
                    'Corporate Video',
                  ]),
                  const SizedBox(height: 12),
                  _buildTextField('Tell us about your event...', maxLines: 4),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Inquiry sent! We\'ll contact you soon.',
                            ),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4D9C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Send Inquiry',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1A4D9C), size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 14,
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
        ),
      ),
    );
  }

  Widget _buildHoursRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          hours,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A4D9C), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A4D9C), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option, style: GoogleFonts.inter(fontSize: 14)),
        );
      }).toList(),
      onChanged: (String? value) {},
    );
  }
}
