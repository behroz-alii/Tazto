import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazto/Presentation/restaurantModel.dart';
import 'restaurantMenuPage.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/services/cartProvider.dart';

class RestaurantsPage extends StatelessWidget {
  final String categoryName;
  final List<Restaurant> restaurants;

  const RestaurantsPage({
    Key? key,
    required this.categoryName,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Restaurants',
            style: TextStyle(fontWeight: FontWeight.w400)),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantMenuPage(
                        restaurant: restaurant,
                        cart: cartProvider,
                        onCartUpdated: () => cartProvider.notifyListeners(),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(restaurant.logoPath),
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
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(
                                  ' ${restaurant.rating} (${restaurant.reviewCount})',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                Text(
                                  ' ${restaurant.distance} km',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}