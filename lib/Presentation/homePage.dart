import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tazto/Presentation/profilePage.dart';
import 'package:tazto/Presentation/restaurantsPage.dart';
import 'package:tazto/Presentation/restaurantModel.dart';
import 'package:tazto/Presentation/messagePage.dart';
import 'package:tazto/Presentation/aiChatPage.dart';
import 'package:tazto/Presentation/cartPage.dart';
import 'package:tazto/services/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:tazto/Presentation/ordersPage.dart';
import 'package:tazto/services/searchService.dart';
import 'package:tazto/Presentation/restaurantMenuPage.dart';
import 'package:tazto/Presentation/locationPickerPage.dart';

// 1. Heart Icon Toggle Widget
class HeartIconToggle extends StatefulWidget {
  const HeartIconToggle({super.key});

  @override
  _HeartIconToggleState createState() => _HeartIconToggleState();
}

class _HeartIconToggleState extends State<HeartIconToggle> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: isLiked ? 1.2 : 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        );
      },
    );
  }
}

// 2. Deals Slider
class DealsSlider extends StatelessWidget {
  final List<String> adImages;

  const DealsSlider({required this.adImages, super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 8),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.95,
      ),
      items: adImages.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(item),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// 3. Custom Container
class CustomContainer extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CustomContainer({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 50,
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Deals Widget
class Deals extends StatelessWidget {
  final String title;
  final String imgPath;
  final String distance;
  final String review;
  final String price;

  const Deals({
    required this.title,
    required this.imgPath,
    required this.distance,
    required this.review,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgPath,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(distance),
                  const Text(' | '),
                  Text(review),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  const HeartIconToggle(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. HomePage Widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const MyOrdersPage(),
      const OrderMessagesPage(),
      Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return CartPage(
            cart: cartProvider,
            onCartUpdated: () => cartProvider.notifyListeners(),
          );
        },
      ),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.copy),
                label: 'Orders',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            cart.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
      floatingActionButton: _selectedIndex != 3 ? FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AIChatWidget(),
          );
        },
        child: const Icon(Icons.android, size: 28, color: Colors.white),
      ) : null,
    );
  }
}

// 6. HomeContent Widget
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();
  final List<String> adImages = [
    'Assets/Deals/Deal 1.jpg',
    'Assets/Deals/Deal 2.jpg',
    'Assets/Deals/Deal 3.jpg',
  ];
  String _currentAddress = '123 Demo Street';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final SearchService _searchService = SearchService(getMockRestaurants());
  List<SearchResult> _searchResults = [];
  bool _showSearchResults = false;

  final List<Map<String, String>> recommendation = [
    {
      'title': 'Biryani',
      'distance': '3km',
      'review': '⭐ 4.8 (2.7k)',
      'price': 'Rs. 550',
      'imgPath': 'Assets/Pictures/items/Biryani.png'
    },
    {
      'title': 'Burger',
      'distance': '1.5km',
      'review': '⭐ 4.2 (91)',
      'price': 'Rs. 900',
      'imgPath': 'Assets/Pictures/items/Burger 2.jpg'
    },
    {
      'title': 'Pizza',
      'distance': '0.9km',
      'review': '⭐ 4.6 (900)',
      'price': 'Rs. 2200',
      'imgPath': 'Assets/Pictures/items/Pizza.jpg'
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = _searchService.search(query);
        _showSearchResults = true;
      });
    } else {
      setState(() {
        _showSearchResults = false;
        _searchResults.clear();
      });
    }
  }

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
      setState(() {
        _showSearchResults = false;
      });
    }
  }

  void _navigateToCategory(String categoryName, FoodCategory category) {
    final filteredRestaurants = getMockRestaurants()
        .where((restaurant) => restaurant.categories.contains(category))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantsPage(
          categoryName: categoryName,
          restaurants: filteredRestaurants,
        ),
      ),
    );
  }

  void _navigateToRestaurantMenu(Restaurant restaurant, {MenuItem? highlightItem}) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantMenuPage(
          restaurant: restaurant,
          cart: cartProvider,
          onCartUpdated: () => cartProvider.notifyListeners(),
          highlightItem: highlightItem,
        ),
      ),
    ).then((_) {
      // Clear search when returning
      setState(() {
        _searchController.clear();
        _showSearchResults = false;
      });
      _searchFocusNode.unfocus();
    });
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No results found'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final result = _searchResults[index];
          return ListTile(
            leading: result.type == SearchResultType.restaurant
                ? Image.asset(result.restaurant.logoPath, width: 40, height: 40)
                : Image.asset(result.menuItem!.imagePath, width: 40, height: 40),
            title: Text(
              result.type == SearchResultType.restaurant
                  ? result.restaurant.name
                  : result.menuItem!.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: result.type == SearchResultType.menuItem
                ? Text('Rs. ${result.menuItem!.price.toStringAsFixed(2)} - ${result.restaurant.name}')
                : Text('Restaurant - ${result.restaurant.menuItems.length} items'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToRestaurantMenu(
                result.restaurant,
                highlightItem: result.menuItem,
              );
            },
          );
        },
        childCount: _searchResults.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _showSearchResults
          ? CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.orangeAccent,
            pinned: true,
            floating: true,
            title: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: "Search meals or restaurants",
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _showSearchResults = false;
                    });
                  },
                )
                    : null,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          _buildSearchResults(),
        ],
      )
          : CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.orangeAccent,
            expandedHeight: 270,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.orangeAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LocationPickerPage()),
                              );

                              if (result != null) {
                                setState(() {
                                  _currentAddress = result["address"];
                                });
                              }
                            },
                            child: const Icon(FontAwesomeIcons.locationArrow, color: Colors.deepOrange),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _currentAddress,
                              style: const TextStyle(fontSize: 17, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: "Search meals or restaurants",
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Get unlimited\nfree delivery\nwith Tazto',
                            style: TextStyle(
                              fontFamily: 'Anton',
                              color: Colors.white,
                              fontSize: 30,
                              letterSpacing: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Column(
                              children: [
                                Image.asset(
                                  'Assets/Pictures/PizzaHut.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 10),
                                Image.asset(
                                  'Assets/Pictures/StarBucks.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  'Assets/Pictures/TacoBell.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 10),
                                Image.asset(
                                  'Assets/Pictures/Yums.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Special Offers!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                DealsSlider(adImages: adImages),
                const SizedBox(height: 5),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: [
                    CustomContainer(
                      title: "Hot Deals",
                      imagePath: "Assets/icons/hot-deal.png",
                      onTap: () => _navigateToCategory('Hot Deals', FoodCategory.HotDeals),
                    ),
                    CustomContainer(
                      title: "Burgers",
                      imagePath: "Assets/icons/Burger.png",
                      onTap: () => _navigateToCategory('Burgers', FoodCategory.Burgers),
                    ),
                    CustomContainer(
                      title: "Pizza",
                      imagePath: "Assets/icons/pizza.png",
                      onTap: () => _navigateToCategory('Pizza', FoodCategory.Pizza),
                    ),
                    CustomContainer(
                      title: "Noodles",
                      imagePath: "Assets/icons/noodle.png",
                      onTap: () => _navigateToCategory('Noodles', FoodCategory.Noodles),
                    ),
                    CustomContainer(
                      title: "Meat",
                      imagePath: "Assets/icons/meat.png",
                      onTap: () => _navigateToCategory('Meat', FoodCategory.Meat),
                    ),
                    CustomContainer(
                      title: "Vege",
                      imagePath: "Assets/icons/vegetarian.png",
                      onTap: () => _navigateToCategory('Vege', FoodCategory.Vege),
                    ),
                    CustomContainer(
                      title: "Desserts",
                      imagePath: "Assets/icons/dessert.png",
                      onTap: () => _navigateToCategory('Desserts', FoodCategory.Desserts),
                    ),
                    CustomContainer(
                      title: "Drinks",
                      imagePath: "Assets/icons/drinks.png",
                      onTap: () => _navigateToCategory('Drinks', FoodCategory.Drinks),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, isDarkMode ? Colors.grey[900]! : Colors.white],
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended for you 😍',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendation.length,
                    itemBuilder: (context, index) {
                      final item = recommendation[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Deals(
                          title: item['title']!,
                          imgPath: item['imgPath']!,
                          distance: item['distance']!,
                          review: item['review']!,
                          price: item['price']!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}