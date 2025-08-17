// models/restaurant_model.dart
import 'dart:io';

enum FoodCategory { HotDeals, Burgers, Pizza, Noodles, Meat, Vege, Desserts, Drinks }

class MenuItem {
  final String name;
  final double price;
  final String description;
  final String imagePath;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String logoPath;
  final String promotedPicturePath;
  final List<FoodCategory> categories;
  final List<MenuItem> menuItems;
  final double distance;
  final double rating;
  final int reviewCount;

  Restaurant({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.promotedPicturePath,
    required this.categories,
    required this.menuItems,
    this.distance = 0,
    this.rating = 0,
    this.reviewCount = 0,
  }) {
    // Validate required fields
    assert(logoPath.isNotEmpty, 'logoPath cannot be empty');
    assert(promotedPicturePath.isNotEmpty, 'promotedPicturePath cannot be empty');
  }
}

// Mock data generator
List<Restaurant> getMockRestaurants() {
  return [
    Restaurant(
      id: '1',
      name: 'Pizza Hut',
      logoPath: 'Assets/Pictures/PizzaHut.png',
      promotedPicturePath: 'Assets/Pictures/items/Pizza.jpg',
      categories: [FoodCategory.Pizza, FoodCategory.Drinks],
      menuItems: [
        MenuItem(
          name: 'Margherita',
          price: 5.99,
          description: 'Classic Pizza',
          imagePath: 'Assets/Pictures/items/Pizza.jpg',
        ),
      ],
      distance: 1.2,
      rating: 4.5,
      reviewCount: 1243,
    ),
    Restaurant(
      id: '2',
      name: 'Taco Bell',
      logoPath: 'Assets/Pictures/TacoBell.png',
      promotedPicturePath: 'Assets/Pictures/items/Burger 2.jpg',
      categories: [FoodCategory.Burgers, FoodCategory.Drinks, FoodCategory.Desserts],
      menuItems: [
        MenuItem(
          name: 'Classic Star',
          price: 12.99,
          description: 'Minced Beef with Home-made sauce, fresh onions, cheese, lettuce and brioche bun',
          imagePath: 'Assets/Pictures/items/Burger 2.jpg',
        ),
      ],
      distance: 2.5,
      rating: 4.2,
      reviewCount: 892,
    ),

  ];
}