import 'package:flutter/material.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages {
    return [
      HomePageContent(
        onCartTap: () => changePage(3),
      ),
      const CategoriesPage(),
      const FavoritesPage(),
      const CartPage(),
      ProfilePage(
        onFavoritesTap: () {
          changePage(2);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;

    return Scaffold(
      drawer: _buildDrawer(),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A0E2E),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: changePage,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFE58AC0),
          unselectedItemColor: Colors.white38,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A0E2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF2D1B4E)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AROMA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Luxury Perfume Collection',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFFE58AC0)),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              changePage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.grid_view, color: Color(0xFFE58AC0)),
            title: const Text('Categories', style: TextStyle(color: Colors.white)),
            onTap: () {
              changePage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Color(0xFFE58AC0)),
            title: const Text('Favorites', style: TextStyle(color: Colors.white)),
            onTap: () {
              changePage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xFFE58AC0)),
            title: const Text('Cart', style: TextStyle(color: Colors.white)),
            onTap: () {
              changePage(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFFE58AC0)),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              changePage(4);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}