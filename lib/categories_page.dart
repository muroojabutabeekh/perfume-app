import 'package:flutter/material.dart';
import 'all_perfumes_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'label': 'Women',
      'subtitle': 'Perfumes',
      'image': 'assets/images/imgs/Versace Pink.png',
      'color1': Color(0xFF8B1A6B),
      'color2': Color(0xFFB5397A),
    },
    {
      'label': 'Men',
      'subtitle': 'Perfumes',
      'image': 'assets/images/imgs/Sauvage.png',
      'color1': Color(0xFF1A1A4E),
      'color2': Color(0xFF2D2D7A),
    },
    {
      'label': 'Unisex',
      'subtitle': 'Perfumes',
      'image': 'assets/images/imgs/Goucci.png',
      'color1': Color(0xFF6B1A8B),
      'color2': Color(0xFF8B3AAA),
    },
    {
      'label': 'Luxury',
      'subtitle': 'Perfumes',
      'image': 'assets/images/imgs/Embrace Gold.png',
      'color1': Color(0xFF4A1560),
      'color2': Color(0xFF7B2D8B),
    },
  ];

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
            // ── AppBar ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // ── Grid ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(context, categories[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllPerfumesPage(filterCategory: category['label']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // نستخدم لون ثابت أو خفيف ليعطي تباين مع الصورة
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            // 1. الصورة التي تغطي الكارد بالكامل
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // هامش بسيط لتبدو الصورة داخل الإطار
                child: Image.asset(
                  category['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 2. طبقة تغميق خفيفة (Overlay) لجعل النص مقروءاً
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.3),
              ),
            ),

            // 3. النص
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['label'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    category['subtitle'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
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