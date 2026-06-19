class CartData {
  static List<Map<String, dynamic>> cartItems = [];

  static double get total => cartItems.fold(0.0, (sum, item) {
    final price = double.parse(
      (item['price'] as String).replaceAll('\$', ''),
    );
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