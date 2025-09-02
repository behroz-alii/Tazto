import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tazto/Presentation/paymnetMethodPage.dart';
import 'package:tazto/Presentation/orderConfirmationPage.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/services/cartProvider.dart';
import 'package:tazto/services/orderProvider.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount; // total in USD
  final int itemCount;

  const CheckoutPage({
    super.key,
    required this.totalAmount,
    required this.itemCount,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedAddress = 'home';
  String selectedPaymentMethod = 'Select Payment Method';

  /// Converts total amount in USD to cents for Stripe
  int get totalAmountInCents => (widget.totalAmount * 100).toInt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAddressOption('Home', 'home', '123 Main St, City', FontAwesomeIcons.house),
            _buildAddressOption('Office', 'office', '456 Office Rd, Business District', FontAwesomeIcons.building),
            _buildAddressOption('Other', 'other', 'Specify delivery location', FontAwesomeIcons.mapLocation),

            const SizedBox(height: 24),

            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.deepOrange),
              title: Text(selectedPaymentMethod),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                // Pass the actual cart amount in cents
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentMethodPage(
                        cartAmount: totalAmountInCents,
                      totalAmount: widget.totalAmount,
                      address: selectedAddress,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    selectedPaymentMethod = result;
                  });
                }
              },
            ),

            const Spacer(),

            // Order Summary
            _buildOrderSummary(),

            const SizedBox(height: 16),

            // Confirm Order Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedPaymentMethod == 'Select Payment Method') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a payment method')),
                  );
                  return;
                }

                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                final orderProvider = Provider.of<OrderProvider>(context, listen: false);

                // DEBUG: Check cart contents
                print('🛒 Cart items count: ${cartProvider.items.length}');
                print('🏪 Restaurant: ${cartProvider.restaurantName}');

                for (var item in cartProvider.items) {
                  print('📦 Cart item: ${item.name} x${item.quantity}');
                }

                final deliveryFee = 2.99;
                final tax = widget.totalAmount * 0.08;
                final totalWithFees = widget.totalAmount + deliveryFee + tax;

                // Create a DEEP COPY (important!)
                List<CartItem> orderItems = [];
                for (var cartItem in cartProvider.items) {
                  orderItems.add(CartItem(
                    id: cartItem.id,
                    name: cartItem.name,
                    description: cartItem.description,
                    price: cartItem.price,
                    imagePath: cartItem.imagePath,
                    restaurantName: cartItem.restaurantName, // This should work now
                    restaurantLogo: cartItem.restaurantLogo, // This should work now
                    quantity: cartItem.quantity,
                  ));
                }



                orderProvider.addOrder(
                    orderItems,
                    totalWithFees,
                    cartProvider.restaurantName ?? 'Unknown Restaurant',
                    cartProvider.restaurantLogo ?? ''
                );

                cartProvider.clearCart();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationPage(
                      totalAmount: totalWithFees,
                      address: selectedAddress,
                      paymentMethod: selectedPaymentMethod,
                    ),
                  ),
                );
              },
              child: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressOption(String title, String value, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile(
        title: Row(
          children: [
            Icon(icon, color: _getIconColor(value)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Text(subtitle),
        value: value,
        groupValue: selectedAddress,
        onChanged: (newValue) {
          setState(() {
            selectedAddress = newValue.toString();
          });
        },
        activeColor: Colors.deepOrange,
      ),
    );
  }

  Color _getIconColor(String addressType) {
    switch (addressType) {
      case 'home':
        return Colors.blue;
      case 'office':
        return Colors.purple;
      case 'other':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Items', widget.itemCount.toString()),
            _buildSummaryRow('Delivery', '\$2.99'),
            _buildSummaryRow('Tax', '\$${(widget.totalAmount * 0.08).toStringAsFixed(2)}'),
            const Divider(),
            _buildSummaryRow(
              'Total',
              '\$${(widget.totalAmount + 2.99 + (widget.totalAmount * 0.08)).toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}