import 'package:flutter/material.dart';
import 'favorites_data.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> perfume;

  const ProductDetailsPage({super.key, required this.perfume});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.perfume['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final perfume = widget.perfume;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? const Color(0xFFE58AC0) : Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;

                              widget.perfume['isFavorite'] = isFavorite;

                              if (isFavorite) {
                                if (!FavoritesData.favorites.contains(widget.perfume)) {
                                  FavoritesData.favorites.add(widget.perfume);
                                }
                              } else {
                                FavoritesData.favorites.remove(widget.perfume);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white70),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── صورة العطر ──
                      Center(
                        child: Container(
                          height: 280,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFE58AC0).withOpacity(0.15),
                                const Color(0xFF9B59B6).withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Image.asset(
                            perfume['image'] as String,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── اسم العطر والسعر ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              perfume['name'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              perfume['price'] as String,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE58AC0),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── التقييم ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            ...List.generate(4, (i) => const Icon(
                                Icons.star, color: Color(0x78D8B9D1), size: 18)),
                            const Icon(Icons.star_half,
                                color: Color(0x78D8B9D1), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '${perfume['rating']} (230 Reviews)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── الوصف ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          perfume['description'] as String? ??
                              'A luxurious fragrance with unique notes that blend perfectly to create an unforgettable scent experience.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── الكمية ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                _quantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  },
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                _quantityButton(
                                  icon: Icons.add,
                                  onTap: () => setState(() => quantity++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── زر ADD TO CART ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF08122F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    CartData.addToCart(perfume, quantity);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${perfume['name']} added to cart!'),
                                        backgroundColor: const Color(0xFFE58AC0),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'ADD TO CART',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE58AC0),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFavorite = !isFavorite;

                                    widget.perfume['isFavorite'] = isFavorite;

                                    if (isFavorite) {
                                      if (!FavoritesData.favorites.contains(widget.perfume)) {
                                        FavoritesData.favorites.add(widget.perfume);
                                      }
                                    } else {
                                      FavoritesData.favorites.remove(widget.perfume);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}