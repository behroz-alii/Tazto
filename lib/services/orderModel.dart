import 'package:tazto/services/cartModel.dart';
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  final String status; // e.g. "Pending", "Delivered"

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    this.status = "Pending",
  });
}