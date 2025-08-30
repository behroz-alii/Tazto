import 'package:flutter/material.dart';
import 'package:tazto/Presentation/restaurantModel.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/services/cartProvider.dart';
import 'package:tazto/Presentation/checkoutPage.dart';

class CartPage extends StatefulWidget {
  final CartProvider cart;
  final Function() onCartUpdated;

  const CartPage({
    super.key,
    required this.cart,
    required this.onCartUpdated,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        actions: [
          if (widget.cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  widget.cart.clearCart();
                  widget.onCartUpdated();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared')),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cart.items.isEmpty
                ? _buildEmptyCart()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                final item = widget.cart.items[index];
                return _buildCartItem(item);
              },
            ),
          ),
          if (widget.cart.items.isNotEmpty) _buildCheckoutSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from restaurants to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.fastfood, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: () {
                      setState(() {
                        if (item.quantity > 1) {
                          item.quantity--;
                        } else {
                          widget.cart.removeItem(item.id);
                        }
                        widget.onCartUpdated();
                      });
                    },
                  ),
                  Text(item.quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      setState(() {
                        item.quantity++;
                        widget.onCartUpdated();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    final deliveryFee = 2.99;
    final tax = widget.cart.totalAmount * 0.08;
    final total = widget.cart.totalAmount + deliveryFee + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', widget.cart.totalAmount),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          _buildSummaryRow('Tax (8%)', tax),
          const Divider(height: 24),
          _buildSummaryRow('Total', total, isTotal: true),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckoutPage(totalAmount: total , itemCount: widget.cart.totalItems ),
                )
              );
            },
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}