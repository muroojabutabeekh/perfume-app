import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            // ── AppBar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ── صورة البروفايل ──
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE58AC0).withOpacity(0.2),
                border: Border.all(color: const Color(0xFFE58AC0), width: 2),
              ),
              child: const Icon(Icons.person, size: 44, color: Color(0xFFE58AC0)),
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),

            const SizedBox(height: 32),

            // ── قائمة الخيارات ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders', () {}),
                  _buildMenuItem(Icons.favorite_border, 'My Favorites', () {}),
                  _buildMenuItem(Icons.location_on_outlined, 'Addresses', () {}),
                  _buildMenuItem(Icons.payment_outlined, 'Payment Methods', () {}),
                  _buildMenuItem(Icons.settings_outlined, 'Settings', () {}),
                  _buildMenuItem(Icons.info_outline, 'About Us', () {}),
                  const SizedBox(height: 16),
                  // زر Logout
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
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Logout',
                              style: TextStyle(color: Colors.red, fontSize: 14)),
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
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE58AC0), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}