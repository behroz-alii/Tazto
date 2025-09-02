import 'package:flutter/material.dart';
import 'package:tazto/Presentation/restaurantModel.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:provider/provider.dart';
import 'package:tazto/Presentation/cartPage.dart';
import 'package:tazto/services/cartProvider.dart';

class RestaurantMenuPage extends StatefulWidget {
  final Restaurant restaurant;
  final CartProvider cart;
  final VoidCallback onCartUpdated;

  const RestaurantMenuPage({
    Key? key,
    required this.restaurant,
    required this.cart,
    required this.onCartUpdated,
  }) : super(key: key);

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  @override

  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.cart.setRestaurantInfo(widget.restaurant.name, widget.restaurant.logoPath);});
    return Scaffold(
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Stack(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cart: widget.cart,
                        onCartUpdated: widget.onCartUpdated,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.shopping_cart),
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cart.totalItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.restaurant.promotedPicturePath,
                fit: BoxFit.cover,
              ),
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = widget.restaurant.menuItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Colors.orange),
                                onPressed: () {
                                  widget.cart.addItem(item);
                                  widget.onCartUpdated();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item.name} added to cart'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: widget.restaurant.menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}