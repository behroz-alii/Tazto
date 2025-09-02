import 'package:tazto/services/cartModel.dart';
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  final String status;
  final String restaurantName;
  final String restaurantLogo;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    required this.restaurantName,
    required this.restaurantLogo,
    this.status = "Pending",
  });
}