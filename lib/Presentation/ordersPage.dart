import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazto/services/orderProvider.dart';
import 'package:tazto/services/orderModel.dart';
import 'package:lottie/lottie.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: orderProvider.orders.isEmpty
          ? _buildNoOrdersAnimation(context)
          : Column(
        children: [
          _buildOngoingOrdersAnimation(context),
          Expanded(
            child: ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (ctx, i) {
                final order = orderProvider.orders[i];
                return _buildOrderCard(context, order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingOrdersAnimation(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 400;
        final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

        return Container(
          height: isSmallScreen ? 120 : isMediumScreen ? 140 : 160, // Increased height
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: isSmallScreen ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Animation on the LEFT - Responsive size
                Lottie.asset(
                  'Assets/Animations/Delivery Service man.json',
                  width: isSmallScreen ? 100 : isMediumScreen ? 140 : 160, // Increased width
                  height: isSmallScreen ? 100 : isMediumScreen ? 140 : 160, // Increased height
                  fit: BoxFit.cover,
                ),
                // Text on the RIGHT - Responsive font size
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Orders in progress!",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    Text(
                      "Your food is being prepared",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Card(
      margin: EdgeInsets.all(isSmallScreen ? 8 : 10),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order.id.substring(0, 8)}...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${order.totalAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            const SizedBox(height: 4),
            Text(
              "Date: ${_formatDate(order.dateTime)}",
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${order.status}",
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                color: order.status == "Delivered" ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (order.status == "Pending" || order.status == "Preparing")
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Estimated delivery: 40-50 minutes",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOrdersAnimation(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'Assets/Animations/No orders.json',
              width: isSmallScreen ? 200 : 250,
              height: isSmallScreen ? 200 : 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              "No orders yet",
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your delicious meals will appear here",
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: isSmallScreen ? 150 : 180,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                    horizontal: 20,
                  ),
                ),
                child: Text(
                  "Order Now",
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}