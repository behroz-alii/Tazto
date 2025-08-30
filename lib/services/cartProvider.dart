import 'package:flutter/material.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/Presentation/restaurantModel.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(MenuItem menuItem) {
    final existingIndex = _items.indexWhere((item) => item.id == menuItem.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        id: menuItem.id,
        name: menuItem.name,
        description: menuItem.description,
        price: menuItem.price,
        imagePath: menuItem.imagePath,
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}