import 'package:flutter/material.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/services/orderModel.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> cartItems, double total, String restaurantName, String restaurantLogo) {
    // DEBUG: Check what items we're receiving
    print('🔄 OrderProvider.addOrder() called');
    print('📦 Items received: ${cartItems.length}');
    for (var item in cartItems) {
      print('   - ${item.name} x${item.quantity}');
    }

    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        items: cartItems, // This should be the cart items
        totalAmount: total,
        dateTime: DateTime.now(),
        restaurantName: restaurantName,
        restaurantLogo: restaurantLogo,
      ),
    );

    // DEBUG: Check what's stored
    print('💾 Order stored with ${_orders.first.items.length} items');
    notifyListeners();
  }
}