// home_screen.dart
import 'package:flutter/material.dart';
import 'custom_bottom_navbar.dart';
import 'screens/home_tab.dart';
import 'screens/portfolio_tab.dart';
import 'screens/packages_tab.dart';
import 'screens/contact_tab.dart';
import 'screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Home is selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PortfolioTab(),
          PackagesTab(),
          HomeTab(onNavigate: _onItemTapped),
          ContactTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
