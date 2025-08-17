import 'package:flutter/material.dart';
import 'restaurantModel.dart';

class RestaurantMenuPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantMenuPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildPromotedImage(),
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = restaurant.menuItems[index];
                  return _buildMenuItem(item);
                },
                childCount: restaurant.menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotedImage() {
    try {
      return Image.asset(
        restaurant.promotedPicturePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildMenuItem(MenuItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Item Image with error handling
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => _buildPlaceholder(),
                ),
              ),
            ),
            SizedBox(width: 12),

            // Item Details
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

            // Price and Add Button
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
                    // Add to cart functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.restaurant, size: 50, color: Colors.grey[400]),
    );
  }
}