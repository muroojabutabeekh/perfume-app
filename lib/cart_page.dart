import 'package:flutter/material.dart';

class CartData {
  static List<Map<String, dynamic>> cartItems = [];

  static double get total => cartItems.fold(0.0, (sum, item) {
    final price = double.parse(
        (item['price'] as String).replaceAll('\$', ''));
    return sum + price * (item['quantity'] as int);
  });

  static void addToCart(Map<String, dynamic> perfume, int quantity) {
    final index = cartItems.indexWhere((p) => p['name'] == perfume['name']);
    if (index != -1) {
      cartItems[index]['quantity'] += quantity;
    } else {
      cartItems.add({...perfume, 'quantity': quantity});
    }
  }

  static void removeFromCart(String name) {
    cartItems.removeWhere((p) => p['name'] == name);
  }

  static void updateQuantity(String name, int quantity) {
    final index = cartItems.indexWhere((p) => p['name'] == name);
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index]['quantity'] = quantity;
      }
    }
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartData.cartItems;
    final total = CartData.total;

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
                    'My Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (cartItems.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(() => CartData.cartItems.clear()),
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                ],
              ),
            ),

            // ── المحتوى ──
            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) =>
                    _buildCartItem(cartItems[index]),
              ),
            ),

            // ── الإجمالي وزر Checkout ──
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0E2E),
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                        Text('\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                        Text('\$10.00',
                            style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text('\$${(total + 10).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Color(0xFFE58AC0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF08122F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully! 🎉'),
                              backgroundColor: Color(0xFFE58AC0),
                            ),
                          );
                          setState(() => CartData.cartItems.clear());
                        },
                        child: const Text('CHECKOUT',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.white54)),
          const SizedBox(height: 8),
          const Text('Add perfumes to your cart',
              style: TextStyle(fontSize: 13, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
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
              width: 85,
              height: 85,
              color: const Color(0xFFE58AC0).withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: Image.asset(item['image'] as String, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] as String,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(item['price'] as String,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE58AC0),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => CartData.removeFromCart(item['name'])),
                  child: const Icon(Icons.delete_outline, color: Colors.white38, size: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qtyBtn(Icons.remove, () {
                      setState(() => CartData.updateQuantity(
                          item['name'], (item['quantity'] as int) - 1));
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('${item['quantity']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    _qtyBtn(Icons.add, () {
                      setState(() => CartData.updateQuantity(
                          item['name'], (item['quantity'] as int) + 1));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}