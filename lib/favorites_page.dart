import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'favorites_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> get favorites => FavoritesData.favorites;

  void removeFromFavorites(int index) {
    setState(() {
      favorites[index]['isFavorite'] = false;
      favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D1B4E), Color(0xFF1A0E2E), Color(0xFF3D1040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── AppBar بدون زر رجوع ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Favorites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70),
                    onPressed: favorites.isEmpty
                        ? null
                        : () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF2D1B4E),
                          title: const Text('Clear Favorites',
                              style: TextStyle(color: Colors.white)),
                          content: const Text(
                              'Remove all items from favorites?',
                              style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white54)),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() => favorites.clear());
                                Navigator.pop(context);
                              },
                              child: const Text('Clear',
                                  style: TextStyle(color: Color(0xFFE58AC0))),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── المحتوى ──
            Expanded(
              child: favorites.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: favorites.length,
                itemBuilder: (context, index) => _buildFavoriteItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.white54)),
          const SizedBox(height: 8),
          const Text('Add perfumes to your favorites',
              style: TextStyle(fontSize: 13, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(int index) {
    final item = favorites[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(perfume: favorites[index]),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 90,
                height: 90,
                color: const Color(0xFFE58AC0).withOpacity(0.1),
                padding: const EdgeInsets.all(8),
                child: Image.asset(item['image'] as String, fit: BoxFit.contain),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] as String,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Color(0xFFFFD700)),
                        const SizedBox(width: 4),
                        Text('${item['rating']}',
                            style: const TextStyle(fontSize: 11, color: Colors.white54)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item['price'] as String,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE58AC0))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => removeFromFavorites(index),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE58AC0).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, size: 18, color: Color(0xFFE58AC0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}