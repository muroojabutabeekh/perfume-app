import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  List<Map<String, dynamic>> get orders => _orders;

  double get total {
    double sum = 0;

    for (var item in _cartItems) {
      final price = double.parse(
        item['price'].toString().replaceAll('\$', ''),
      );

      sum += price * item['quantity'];
    }

    return sum;
  }

  void addToCart(
      Map<String, dynamic> perfume,
      int quantity,
      ) {
    final index = _cartItems.indexWhere(
          (item) => item['name'] == perfume['name'],
    );

    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({
        ...perfume,
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  void updateQuantity(String name, int quantity) {
    final index = _cartItems.indexWhere(
          (item) => item['name'] == name,
    );

    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index]['quantity'] = quantity;
      }

      notifyListeners();
    }
  }

  void removeItem(String name) {
    _cartItems.removeWhere(
          (item) => item['name'] == name,
    );

    notifyListeners();
  }

  void checkout() {
    if (_cartItems.isEmpty) return;

    _orders.add({
      'date': DateTime.now(),
      'items': _cartItems
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
    });

    _cartItems.clear();

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}