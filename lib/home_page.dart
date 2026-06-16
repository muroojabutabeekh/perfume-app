import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'all_perfumes_page.dart';
import 'favorites_page.dart';
import 'favorites_data.dart';
import 'perfumes_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredPerfumes = [];

  @override
  void initState() {
    super.initState();
    _filteredPerfumes = perfumes;
    _searchController.addListener(() {
      setState(() {
        _filteredPerfumes = perfumes
            .where((p) => (p['name'] as String)
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> categories = [
    {'label': 'Women', 'icon': Icons.female},
    {'label': 'Men', 'icon': Icons.male},
    {'label': 'Unisex', 'icon': Icons.people},
    {'label': 'Luxury', 'icon': Icons.diamond_outlined},
  ];

  final perfumes = PerfumesData.perfumes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2D1B4E),
              Color(0xFF1A0E2E),
              Color(0xFF3D1040),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildBanner(),
                      const SizedBox(height: 24),

                      // هنا قمنا بإعادة استدعاء دالة التصنيفات الصحيحة
                      _buildSectionHeader('Popular Perfumes', onViewAll: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AllPerfumesPage(),
                        ));
                      }),
                      const SizedBox(height: 14),
                      _buildCategories(),

                      const SizedBox(height: 24),
                      _buildSectionHeader('Categories', onViewAll: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AllPerfumesPage(),
                        ));
                      }),
                      const SizedBox(height: 14),

                      // هنا الـ Grid الخاص بالعطور يعمل تلقائياً من القائمة
                      _buildPerfumeGrid(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // هنا نستدعي البوتوم نافيجيشن المخصص الذي عدلناه سابقاً
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── AppBar ──
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white70),
            onPressed: () {},
          ),
          const Expanded(
            child: Text(
              'AROMA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 6,
                color: Colors.white,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white70),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE58AC0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => AllPerfumesPage(searchQuery: value),
            ));
          }
        },
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search perfumes...',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          prefixIcon:
          const Icon(Icons.search, color: Colors.white38, size: 20),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE58AC0)),
          ),
        ),
      ),
    );
  }

  // ── Banner ──
  // ── Banner ──
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A1560), Color(0xFF7B2D8B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // النص على اليسار
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFFE58AC0),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CHANEL\nNO.5',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Timeless Elegance',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE58AC0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SHOP NOW',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // الصورة على اليمين — عرض ثابت
            SizedBox(
              width: 120,
              height: double.infinity,
              child: Image.asset(
                'assets/images/imgs/Sanael.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String title,
      {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFE58AC0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Categories ──
  Widget _buildCategories() {
    return SizedBox(
      height: 100, // زيادة الطول قليلاً لاستيعاب الأيقونة والنص
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AllPerfumesPage(
                  filterCategory: categories[index]['label'],
                ),
              ));
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categories[index]['icon'], color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['label'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Perfume Grid ──
  Widget _buildPerfumeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredPerfumes.length,
        itemBuilder: (context, index) {
          return _buildPerfumeCard(index);
        },
      ),
    );
  }

  // Perfume Card
  Widget _buildPerfumeCard(int index) {
    final perfume = _filteredPerfumes[index];
    return GestureDetector(                    // ← أضيفي هاد
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(perfume: _filteredPerfumes[index]),
          ),
        );
      },
      child: Container(                        // ← خليها child
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(perfume['image'], fit: BoxFit.contain),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  perfume['isFavorite']
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xFFE58AC0),
                ),
                onPressed: () {
                  setState(() {
                    perfume['isFavorite'] = !perfume['isFavorite'];

                    if (perfume['isFavorite']) {
                      FavoritesData.favorites.add(perfume);
                    } else {
                      FavoritesData.favorites.remove(perfume);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              perfume['name'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              perfume['price'],
              style: const TextStyle(color: Color(0xFFE58AC0), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation Bar ──
  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF1A0E2E), // لون داكن متناسق مع الخلفية
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, "Home", true),
          _navItem(Icons.grid_view, "Categories", false),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const FavoritesPage(),
            )),
            child: _navItem(Icons.favorite_border, "Favorites", false),
          ),
          _navItem(Icons.shopping_bag_outlined, "Cart", false),
          _navItem(Icons.person_outline, "Profile", false),
        ],
      ),
    );
  }
  Widget _navItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? const Color(0xFFE58AC0) : Colors.white38),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFFE58AC0) : Colors.white38)),
      ],
    );
  }
}








