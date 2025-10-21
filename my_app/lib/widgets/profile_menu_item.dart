// widgets/profile_menu_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF1A4D9C),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: isDestructive ? Colors.red : const Color(0xFF2D3748),
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
