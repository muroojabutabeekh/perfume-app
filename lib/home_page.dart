import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_details_page.dart';
import 'all_perfumes_page.dart';
import 'perfumes_data.dart';
import 'cart_provider.dart';
import 'favorites_provider.dart';

class HomePageContent extends StatefulWidget {
  final VoidCallback? onCartTap;

  const HomePageContent({
    super.key,
    this.onCartTap,
  });

  @override
  State<HomePageContent> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredPerfumes = [];

  final List<Map<String, dynamic>> categories = [
    {'label': 'Women', 'icon': Icons.female},
    {'label': 'Men', 'icon': Icons.male},
    {'label': 'Unisex', 'icon': Icons.people},
    {'label': 'Luxury', 'icon': Icons.diamond_outlined},
  ];

  final perfumes = PerfumesData.perfumes;

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

  void addToCart(Map<String, dynamic> perfume) {
    context.read<CartProvider>().addToCart(perfume, 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${perfume['name']} added to cart'),
        backgroundColor: const Color(0xFFE58AC0),
      ),
    );

    if (widget.onCartTap != null) {
      widget.onCartTap!();
    }
  }

  void toggleFavorite(Map<String, dynamic> perfume) {
    context.read<FavoritesProvider>().toggleFavorite(perfume);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FavoritesProvider>();

    return Container(
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
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildBanner(),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Popular Perfumes', onViewAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPerfumesPage(),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    _buildCategories(),
                    const SizedBox(height: 18),
                    _buildSectionHeader('All Perfumes', onViewAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPerfumesPage(),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    _buildPerfumeGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white70),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
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
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white70,
            ),
            onPressed: widget.onCartTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        height: 42,
        child: TextField(
          controller: _searchController,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllPerfumesPage(searchQuery: value),
                ),
              );
            }
          },
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Search perfumes...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon:
            const Icon(Icons.search, color: Colors.white38, size: 20),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.10),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE58AC0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 118,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A1560), Color(0xFF7B2D8B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFFE58AC0),
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CHANEL NO.5',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Timeless Elegance',
                      style: TextStyle(fontSize: 10, color: Colors.white60),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllPerfumesPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE58AC0),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'SHOP NOW',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 105,
              child: Image.asset(
                'assets/images/imgs/Sanael.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
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

  Widget _buildCategories() {
    return SizedBox(
      height: 82,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllPerfumesPage(
                    filterCategory: categories[index]['label'],
                  ),
                ),
              );
            },
            child: Container(
              width: 96,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE58AC0).withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index]['icon'],
                    color: const Color(0xFFE58AC0),
                    size: 27,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    categories[index]['label'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPerfumeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisExtent: 250,
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

  Widget _buildPerfumeCard(int index) {
    final perfume = _filteredPerfumes[index];

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              perfume: perfume,
              onCartTap: widget.onCartTap,
            ),
          ),
        );

        if (!mounted) return;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.12),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE58AC0).withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  toggleFavorite(perfume);
                },
                child: Icon(
                  perfume['isFavorite']
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xFFE58AC0),
                  size: 18,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Center(
                child: Image.asset(
                  perfume['image'],
                  height: 115,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              perfume['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE58AC0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    perfume['price'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    addToCart(perfume);
                  },
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}