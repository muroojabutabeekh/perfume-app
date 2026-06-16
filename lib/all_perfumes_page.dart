import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'favorites_data.dart';
import 'perfumes_data.dart';


class AllPerfumesPage extends StatefulWidget {
  final String? filterCategory;
  final String? searchQuery;

  const AllPerfumesPage({super.key, this.filterCategory, this.searchQuery});

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
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPerfumes {
    if (selectedCategory == 'All') return allPerfumes;
    return allPerfumes
        .where((p) => p['category'] == selectedCategory)
        .toList();
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
              // ── AppBar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
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

              // ── فلتر Categories ──
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
                      onTap: () => setState(() => selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE58AC0)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE58AC0)
                                : Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white60,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ── عدد النتائج ──
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

              // ── Grid ──
              Expanded(
                child: filteredPerfumes.isEmpty
                    ? const Center(
                  child: Text(
                    'No perfumes found',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsPage(perfume: filteredPerfumes[index]),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
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
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
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
                          const Icon(Icons.star,
                              size: 11, color: Color(0xFFFFD700)),
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