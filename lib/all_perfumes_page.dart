import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'favorites_data.dart';
import 'perfumes_data.dart';
import 'cart_data.dart';

class AllPerfumesPage extends StatefulWidget {
  final String? filterCategory;
  final String? searchQuery;

  const AllPerfumesPage({
    super.key,
    this.filterCategory,
    this.searchQuery,
  });

  @override
  State<AllPerfumesPage> createState() => _AllPerfumesPageState();
}

class _AllPerfumesPageState extends State<AllPerfumesPage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = ['All', 'Women', 'Men', 'Unisex', 'Luxury'];
  final allPerfumes = PerfumesData.perfumes;

  @override
  void initState() {
    super.initState();

    if (widget.filterCategory != null) {
      selectedCategory = widget.filterCategory!;
    }

    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPerfumes {
    return allPerfumes.where((p) {
      final matchesCategory =
          selectedCategory == 'All' || p['category'] == selectedCategory;

      final matchesSearch = (p['name'] as String)
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void addToCart(Map<String, dynamic> perfume) {
    CartData.addToCart(perfume, 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${perfume['name']} added to cart'),
        backgroundColor: const Color(0xFFE58AC0),
      ),
    );
  }

  void toggleFavorite(Map<String, dynamic> perfume) {
    setState(() {
      perfume['isFavorite'] = !perfume['isFavorite'];

      if (perfume['isFavorite']) {
        if (!FavoritesData.favorites.contains(perfume)) {
          FavoritesData.favorites.add(perfume);
        }
      } else {
        FavoritesData.favorites.remove(perfume);
      }
    });
  }

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white70,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'All Perfumes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search perfumes...',
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white38,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE58AC0),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE58AC0)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE58AC0)
                                : Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white60,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${filteredPerfumes.length} perfumes found',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: filteredPerfumes.isEmpty
                    ? const Center(
                  child: Text(
                    'No perfumes found',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredPerfumes.length,
                  itemBuilder: (context, index) {
                    return _buildPerfumeCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfumeCard(int index) {
    final perfume = filteredPerfumes[index];

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(perfume: perfume),
          ),
        );

        if (!mounted) return;

        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        perfume['image'] as String,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        toggleFavorite(perfume);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          perfume['isFavorite'] as bool
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 14,
                          color: perfume['isFavorite'] as bool
                              ? const Color(0xFFE58AC0)
                              : Colors.white60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfume['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        perfume['price'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE58AC0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              addToCart(perfume);
                            },
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ),

                          const SizedBox(width: 8),

                          const Icon(
                            Icons.star,
                            size: 11,
                            color: Color(0xFFFFD700),
                          ),

                          const SizedBox(width: 2),

                          Text(
                            '${perfume['rating']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}