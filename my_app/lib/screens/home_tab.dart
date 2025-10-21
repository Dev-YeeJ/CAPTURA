// screens/home_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/stat_item.dart';

import '../widgets/testimonial_card.dart';
import 'dart:async';

class HomeTab extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeTab({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<SlideData> _slides = [
    SlideData(
      title: 'Professional Videography',
      subtitle: 'Cinematic Storytelling',
      imageUrl:
          'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800',
    ),
    SlideData(
      title: 'Portrait Excellence',
      subtitle: 'Professional studio sessions',
      imageUrl:
          'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=800',
    ),
    SlideData(
      title: 'Wedding Magic',
      subtitle: 'Capturing your special moments',
      imageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousSlide() {
    if (_currentPage > 0) {
      _currentPage--;
    } else {
      _currentPage = _slides.length - 1;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextSlide() {
    if (_currentPage < _slides.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Slider Section
            Container(
              margin: const EdgeInsets.all(16),
              height: 250,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        return _buildSlide(_slides[index]);
                      },
                    ),
                  ),
                  // Left Arrow
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _goToPreviousSlide,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right Arrow
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _goToNextSlide,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Page Indicators
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Service Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.camera_alt,
                          title: 'Photography',
                          onTap: () => widget.onNavigate(0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.videocam,
                          title: 'Videography',
                          onTap: () => widget.onNavigate(0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.inventory_2_outlined,
                          title: 'Packages',
                          onTap: () => widget.onNavigate(1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildServiceButton(
                          icon: Icons.calendar_today,
                          title: 'Book Now',
                          onTap: () => widget.onNavigate(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Captura Studio',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'With 10+ years of experience in capturing life\'s moments, weddings, events, and corporate shoots, we deliver professional photo & video services tailored to your vision.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      StatItem(
                        icon: Icons.groups,
                        value: '10+',
                        label: 'Team Size',
                      ),
                      StatItem(
                        icon: Icons.camera,
                        value: '500+',
                        label: 'Projects',
                      ),
                      StatItem(
                        icon: Icons.stars,
                        value: '1000+',
                        label: 'Clients',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Featured Packages Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Packages',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onNavigate(1),
                    child: Row(
                      children: [
                        Text(
                          'See all',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1A4D9C),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Color(0xFF1A4D9C),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Premium Wedding Package
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Wedding Package',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Luxury wedding coverage with full team',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₱45,000',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeatureRow('10 hour coverage'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('Full Team of Videographers'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('3 Videographers'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeatureRow('Cinematic Highlight Film'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('2 Subcontractors'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('Drone Coverage'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onNavigate(3);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A4D9C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Book Package',
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
            ),

            const SizedBox(height: 16),

            // Product Shoot Package
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Shoot Package',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'High-quality photography for businesses',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₱12,000',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeatureRow('7-day shoot'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('Studio setup for lights'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('3 Videographers'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeatureRow('Professional Shots'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('Social Media Edits'),
                              const SizedBox(height: 8),
                              _buildFeatureRow('Drone Coverage'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onNavigate(3);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A4D9C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Book Package',
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
            ),

            const SizedBox(height: 32),

            // Portfolio Highlights
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Portfolio Highlights',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onNavigate(0),
                    child: Row(
                      children: [
                        Text(
                          'View Gallery',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1A4D9C),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Color(0xFF1A4D9C),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPortfolioCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
                          category: 'Wedding',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPortfolioCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=400',
                          category: 'Portrait',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPortfolioCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1464983308952-034b21630dc5?w=400',
                          category: 'Birthday',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPortfolioCard(
                          imageUrl:
                              'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                          category: 'Product',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Testimonials
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'What Our Clients Say',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  TestimonialCard(
                    name: 'Jaime Yee',
                    initials: 'JY',
                    testimonial:
                        'Absolutely stunning work! They captured every emotion perfectly on our wedding day.',
                    badge: 'Wedding Package',
                  ),
                  SizedBox(height: 12),
                  TestimonialCard(
                    name: 'Leonardo Moter',
                    initials: 'LM',
                    testimonial:
                        'Professional and creative. This corporate video exceeded our expectations.',
                    badge: 'Corporate Video',
                  ),
                  SizedBox(height: 12),
                  TestimonialCard(
                    name: 'Ramo Javier',
                    initials: 'RJ',
                    testimonial:
                        'Great portrait session! Very comfortable and professional environment.',
                    badge: 'Portrait Photography',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // CTA Section
            Container(
              margin: const EdgeInsets.all(16),
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
                  const Icon(Icons.camera_alt, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Ready to Capture Your Story?',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s create beautiful memories together. Book your session today and let us capture your special moments!',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => widget.onNavigate(3),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A4D9C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        'Book Your Session',
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

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(SlideData slide) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(slide.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                slide.title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                slide.subtitle,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Playing showreel...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A4D9C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.play_circle_outline, size: 20),
                label: Text(
                  'Watch our reel',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 16, color: Color(0xFF1A4D9C)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A4D9C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard({
    required String imageUrl,
    required String category,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2D3748),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildServiceButton({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D9C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPortfolioCard({
  required String imageUrl,
  required String category,
}) {
  return Container(
    height: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: GoogleFonts.inter(
                  color: const Color(0xFF2D3748),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class SlideData {
  final String title;
  final String subtitle;
  final String imageUrl;

  SlideData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}
