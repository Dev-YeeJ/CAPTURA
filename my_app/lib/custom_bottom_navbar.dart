// custom_bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.image_outlined,
              label: 'Portfolio',
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Packages',
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            _NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Contact',
              isSelected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isSelected: selectedIndex == 4,
              onTap: () => onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1A4D9C), size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF1A4D9C),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
