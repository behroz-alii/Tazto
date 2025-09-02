import 'package:flutter/material.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/Presentation/restaurantModel.dart';

class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();
  String? _currentRestaurantName;
  String? _currentRestaurantLogo;

  List<CartItem> get items => _cart.items;
  String? get restaurantName => _currentRestaurantName;
  String? get restaurantLogo => _currentRestaurantLogo;

  void setRestaurantInfo(String name, String logo) {
    _currentRestaurantName = name;
    _currentRestaurantLogo = logo;
    notifyListeners();
  }

  void addItem(MenuItem menuItem) {
    _cart.addItem(menuItem, _currentRestaurantName ?? '', _currentRestaurantLogo ?? '');
    notifyListeners();
  }

  void removeItem(String id) {
    _cart.removeItem(id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clearCart();
    _currentRestaurantName = null;
    _currentRestaurantLogo = null;
    notifyListeners();
  }

  double get totalAmount => _cart.totalAmount;
  int get totalItems => _cart.totalItems;
}