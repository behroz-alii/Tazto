import 'package:flutter/material.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/services/orderModel.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        items: cartItems,
        totalAmount: total,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}