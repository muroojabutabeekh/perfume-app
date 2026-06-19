import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onOrdersTap;
  final VoidCallback? onFavoritesTap;

  const ProfilePage({
    super.key,
    this.onOrdersTap,
    this.onFavoritesTap,
  });

  void openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white70),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white70),
                    onPressed: () => openPage(context, const EditProfilePage()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE58AC0).withValues(alpha: 0.2),
                border: Border.all(color: const Color(0xFFE58AC0), width: 2),
              ),
              child: const Icon(Icons.person, size: 44, color: Color(0xFFE58AC0)),
            ),

            const SizedBox(height: 12),

            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuItem(
                    Icons.shopping_bag_outlined,
                    'My Orders',
                        () => openPage(context, const OrdersPage()),
                  ),
                  _buildMenuItem(
                    Icons.favorite_border,
                    'My Favorites',
                        () {
                      if (onFavoritesTap != null) onFavoritesTap!();
                    },
                  ),
                  _buildMenuItem(
                    Icons.location_on_outlined,
                    'Addresses',
                        () => openPage(context, const AddressesPage()),
                  ),
                  _buildMenuItem(
                    Icons.payment_outlined,
                    'Payment Methods',
                        () => openPage(context, const PaymentMethodsPage()),
                  ),
                  _buildMenuItem(
                    Icons.settings_outlined,
                    'Settings',
                        () => openPage(context, const SettingsPage()),
                  ),
                  _buildMenuItem(
                    Icons.info_outline,
                    'About Us',
                        () => openPage(context, const AboutUsPage()),
                  ),

                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Logout',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
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

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE58AC0), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final Widget child;

  const SimplePage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D1B4E),
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: child,
    );
  }
}

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Addresses',
      child: Center(
        child: Text(
          'No addresses added yet',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Payment Methods',
      child: Center(
        child: Text(
          'No payment methods added yet',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget settingItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFE58AC0), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Text(value, style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Settings',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            settingItem(Icons.language, 'Language', 'English'),
            settingItem(Icons.notifications_none, 'Notifications', 'On'),
            settingItem(Icons.dark_mode_outlined, 'Theme', 'Dark'),
            settingItem(Icons.security_outlined, 'Privacy', 'Enabled'),
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'About Us',
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'AROMA is a perfume shopping application built with Flutter. '
              'The app allows users to browse perfumes, view product details, '
              'add products to favorites, and add items to the cart. '
              'It also uses Firebase Authentication for user login and registration, '
              'and Provider for managing cart and favorites state.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Edit Profile',
      child: Center(
        child: Text(
          'Edit profile page',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<CartProvider>().orders;

    return SimplePage(
      title: 'My Orders',
      child: orders.isEmpty
          ? const Center(
        child: Text(
          'No orders yet',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final items = order['items'] as List;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFFE58AC0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          item['image'],
                          width: 45,
                          height: 45,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          'x${item['quantity']}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}