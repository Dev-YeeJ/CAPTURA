// screens/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth_service.dart';
import '../sign_in_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Map<String, dynamic>? user;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _smsNotifications = true;

  @override
  void initState() {
    super.initState();
    user = AuthService.instance.currentUser;
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              AuthService.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: const Color(0xFF1A4D9C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'CS';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final userName = user?['username'] ?? 'Captura Studio';
    final userEmail = user?['email'] ?? 'hello@capturastudio.com';
    final initials = _getInitials(userName);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: const Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
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
            // Profile Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1A4D9C), const Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A4D9C).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Text(
                      initials,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A4D9C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Member since January 2024',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Account Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Account Overview',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.calendar_today,
                      value: '0',
                      label: 'Total Bookings',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.wallet,
                      value: '₱0',
                      label: 'Total Spent',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Information
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Personal Information',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        color: const Color(0xFF2563EB),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: userEmail,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: 'Username',
                    value: userName,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+63 915 537 1154',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: 'San Vicente, Urdaneta Pangasinan',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // My Bookings
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Bookings (0)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Bookings Yet',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ready to capture your moments?',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.explore),
                    label: const Text('Browse Packages'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A4D9C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notifications Preferences
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications Preferences',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose how you\'d like to be notified about your bookings',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationToggle(
                    title: 'Email Notifications',
                    subtitle: 'Booking confirmations and reminders',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() => _emailNotifications = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggle(
                    title: 'Push Notifications',
                    subtitle: 'Important updates and reminders',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() => _pushNotifications = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggle(
                    title: 'SMS Notifications',
                    subtitle: 'Text messages and updates',
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() => _smsNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActionButton(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionButton(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionButton(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => _handleLogout(context),
                    isDestructive: true,
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

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: const Color(0xFF2563EB)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2563EB)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF2D3748),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2563EB),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : const Color(0xFF2563EB),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? Colors.red : const Color(0xFF2D3748),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDestructive ? Colors.red : const Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
