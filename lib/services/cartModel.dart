import 'package:tazto/Presentation/restaurantModel.dart';

class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String restaurantName;
  final String restaurantLogo;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.restaurantName,
    required this.restaurantLogo,
    this.quantity = 1,
  });
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(MenuItem menuItem, String restaurantName, String restaurantLogo) {
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
        restaurantName: restaurantName,
        restaurantLogo: restaurantLogo,
      ));
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void clearCart() {
    _items.clear();
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
