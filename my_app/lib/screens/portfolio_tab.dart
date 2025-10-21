// screens/portfolio_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;

  const PortfolioCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4299E1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioTab extends StatefulWidget {
  const PortfolioTab({Key? key}) : super(key: key);

  @override
  State<PortfolioTab> createState() => _PortfolioTabState();
}

class _PortfolioTabState extends State<PortfolioTab> {
  String selectedFilter = 'All';

  final List<String> filterOptions = [
    'All',
    'Wedding',
    'Corporate',
    'Portrait',
    'Product',
    'Birthday',
    'Graduation',
    'Baptism',
    'Branding',
  ];

  final List<Map<String, String>> portfolioItems = [
    {
      'title': "Sarah & Michael's Wedding",
      'category': 'Wedding',
      'image':
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=500&fit=crop',
    },
    {
      'title': 'Mark Portrait Photoshoot',
      'category': 'Portrait',
      'image':
          'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=400&h=500&fit=crop',
    },
    {
      'title': "Sheila's 15th Birthday",
      'category': 'Birthday',
      'image':
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400&h=500&fit=crop',
    },
    {
      'title': "Emilio's Baptism",
      'category': 'Baptism',
      'image':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=500&fit=crop',
    },
    {
      'title': "Kleo & Martin's Wedding",
      'category': 'Wedding',
      'image':
          'https://images.unsplash.com/photo-1560439514-4e9645039924?w=400&h=500&fit=crop',
    },
    {
      'title': "Sarah & Michael's Wedding",
      'category': 'Corporate',
      'image':
          'https://images.unsplash.com/photo-1464983308952-034b21630dc5?w=400&h=500&fit=crop',
    },
    {
      'title': 'Judy Portrait',
      'category': 'Portrait',
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=500&fit=crop',
    },
    {
      'title': 'Undanels City University Graduation Pictorial',
      'category': 'Graduation',
      'image':
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400&h=500&fit=crop',
    },
    {
      'title': "John's 31th Birthday",
      'category': 'Birthday',
      'image':
          'https://images.unsplash.com/photo-1464983308952-034b21630dc5?w=400&h=500&fit=crop',
    },
    {
      'title': 'Project Proposal',
      'category': 'Corporate',
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=500&fit=crop',
    },
    {
      'title': 'PHNMA University Graduation Pictorial',
      'category': 'Graduation',
      'image':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=500&fit=crop',
    },
    {
      'title': 'Skin Care Product',
      'category': 'Product',
      'image':
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400&h=500&fit=crop',
    },
    {
      'title': "Baby Jaime's Baptism",
      'category': 'Baptism',
      'image':
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400&h=500&fit=crop',
    },
    {
      'title': 'Starbucks',
      'category': 'Branding',
      'image':
          'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=400&h=500&fit=crop',
    },
    {
      'title': 'Shoe Product',
      'category': 'Product',
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=500&fit=crop',
    },
    {
      'title': 'Cong Clothing',
      'category': 'Branding',
      'image':
          'https://images.unsplash.com/photo-1506629082632-420aa94c3cf6?w=400&h=500&fit=crop',
    },
  ];

  List<Map<String, String>> getFilteredItems() {
    if (selectedFilter == 'All') {
      return portfolioItems;
    }
    return portfolioItems
        .where((item) => item['category'] == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = getFilteredItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Captura',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: const Color(0xFF2D3748),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: const Color(0xFF2D3748),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Our Portfolio',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = filterOptions[index];
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF2D5AA0),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4299E1),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF2D5AA0)
                            : const Color(0xFF4299E1),
                        width: 1.5,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return PortfolioCard(
                    imageUrl: item['image']!,
                    title: item['title']!,
                    category: item['category']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
