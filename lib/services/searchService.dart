
import 'package:tazto/Presentation/restaurantModel.dart';

class SearchService {
  final List<Restaurant> restaurants;

  SearchService(this.restaurants);

  List<SearchResult> search(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    final results = <SearchResult>[];

    // Search restaurants by name
    for (final restaurant in restaurants) {
      if (restaurant.name.toLowerCase().contains(lowercaseQuery)) {
        results.add(SearchResult(
          type: SearchResultType.restaurant,
          restaurant: restaurant,
          relevance: _calculateRelevance(restaurant.name, lowercaseQuery),
        ));
      }
    }

    // Search menu items by name
    for (final restaurant in restaurants) {
      for (final menuItem in restaurant.menuItems) {
        if (menuItem.name.toLowerCase().contains(lowercaseQuery)) {
          results.add(SearchResult(
            type: SearchResultType.menuItem,
            restaurant: restaurant,
            menuItem: menuItem,
            relevance: _calculateRelevance(menuItem.name, lowercaseQuery),
          ));
        }
      }
    }

    // Sort by relevance (exact matches first)
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return results;
  }

  int _calculateRelevance(String text, String query) {
    final lowercaseText = text.toLowerCase();

    // Exact match gets highest relevance
    if (lowercaseText == query) return 100;

    // Starts with query gets high relevance
    if (lowercaseText.startsWith(query)) return 90;

    // Contains query gets medium relevance
    if (lowercaseText.contains(query)) return 80;

    return 50;
  }
}

enum SearchResultType { restaurant, menuItem }

class SearchResult {
  final SearchResultType type;
  final Restaurant restaurant;
  final MenuItem? menuItem;
  final int relevance;

  SearchResult({
    required this.type,
    required this.restaurant,
    this.menuItem,
    required this.relevance,
  });
}