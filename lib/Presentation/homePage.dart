import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tazto/Presentation/profilePage.dart';

// 1. Heart Icon Toggle Widget
class HeartIconToggle extends StatefulWidget {
  const HeartIconToggle({Key? key}) : super(key: key);

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

// 2. Deals Slider Widget
class DealsSlider extends StatelessWidget {
  final List<String> adImages;

  const DealsSlider({required this.adImages, Key? key}) : super(key: key);

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
              margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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

// 3. Custom Container Widget
class CustomContainer extends StatelessWidget {
  final String title;
  final String imagePath;

  const CustomContainer({
    required this.title,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    Key? key,
  }) : super(key: key);

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

// 5. Main Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeContent(),
    const Center(child: Text('Orders Page')),
    const Center(child: Text('Messages Page')),
    const Center(child: Text('Cart Page')),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.copy),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// 6. Home Content Widget
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

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
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(FontAwesomeIcons.locationArrow, color: Colors.deepOrange),
                        SizedBox(width: 5),
                        Text(
                          '123 Demo Street',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        Spacer(),
                        Icon(FontAwesomeIcons.bell, color: Colors.white),
                        SizedBox(width: 5),
                        Icon(FontAwesomeIcons.heart, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search meals or restaurants",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
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
                          padding: const EdgeInsets.only(left: 95),
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
                    const Text(
                      'Special Offers!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
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
                children: const [
                  CustomContainer(
                    title: "Hot Deals",
                    imagePath: "Assets/icons/hot-deal.png",
                  ),
                  CustomContainer(
                    title: "Burgers",
                    imagePath: "Assets/icons/Burger.png",
                  ),
                  CustomContainer(
                    title: "Pizza",
                    imagePath: "Assets/icons/pizza.png",
                  ),
                  CustomContainer(
                    title: "Noodles",
                    imagePath: "Assets/icons/noodle.png",
                  ),
                  CustomContainer(
                    title: "Meat",
                    imagePath: "Assets/icons/meat.png",
                  ),
                  CustomContainer(
                    title: "Vege",
                    imagePath: "Assets/icons/vegetarian.png",
                  ),
                  CustomContainer(
                    title: "Desserts",
                    imagePath: "Assets/icons/dessert.png",
                  ),
                  CustomContainer(
                    title: "Drinks",
                    imagePath: "Assets/icons/drinks.png",
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.white],
                  ),
                ),
                padding: const EdgeInsets.only(left: 10),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recommended for you 😍',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
    );
  }
}