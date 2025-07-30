import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeartIconToggle extends StatefulWidget {
  @override
  _HeartIconToggleState createState() => _HeartIconToggleState();
}
//Creating like functionality so that button changes its colour when clicked and show pop effect
class _HeartIconToggleState extends State<HeartIconToggle> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 1.0,
        end: isLiked ? 1.2 : 1.0,
      ),
      duration: Duration(milliseconds: 200),
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


class DealsSlider extends StatelessWidget {
  final List<String> adImages = [
    'Assets/Deals/Deal 1.jpg',
    'Assets/Deals/Deal 2.jpg',
    'Assets/Deals/Deal 3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 8),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.95,
        aspectRatio: 18 / 9,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
      ),
      items: adImages.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Scroll Controller for color changing app bar
  ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // index for bottom navigation
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //
          SliverAppBar(
            backgroundColor: Colors.orangeAccent,
            expandedHeight: 280,
            pinned: true,
            // Keeps a portion visible when collapsed
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.orangeAccent,
                    Colors.orangeAccent.withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Icons and Address
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.menu, color: Colors.black),
                              SizedBox(width: 8),
                              Icon(Icons.location_on_rounded,
                                  color: Colors.deepOrange),
                              Text(
                                '123 Demo Street',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          Icon(
                            Icons.notifications_active_outlined,
                          ),
                          Icon(Icons.shopping_bag_outlined,
                              color: Colors.black),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search Field
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search meals or restaurants",
                          prefixIcon: Icon(Icons.search),
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
                            'Get unlimited\nfree delivery with\nTazto',
                            style: TextStyle(
                              fontFamily: 'Anton',
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 70),
                            child: Column(
                              children: [
                                Image.asset(
                                  'Assets/Pictures/PizzaHut.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'Assets/Pictures/StarBucks.png',
                                  width: 50,
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  'Assets/Pictures/TacoBell.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'Assets/Pictures/Yums.png',
                                  width: 50,
                                  height: 50,
                                )
                              ],
                            ),
                          )
                        ],
                      )

                      // Offer Text and Logos

                      //  Text('Get unlimited free delivery with  tazto')
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  //SLIDER
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Special Offers!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Spacer(),
                      GestureDetector(
                          child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      const SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DealsSlider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Row(
                          children: [
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
                          ],
                        ),
                        const Row(
                          children: [
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
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Recommended for you 😍', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.orange ),)),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15), topRight: Radius.circular(15))
                          ),
                          child: Row(
                            children: [
                              const Deals(
                                  title: 'Biryani',
                                  imgPath: 'Assets/Pictures/items/Biryani.jpg',
                                  distance: '5km',
                                  review: '⭐ 4.8 (2.7k)',
                                  price: '5.50'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
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
            icon: Icon(Icons.restaurant_menu),
            label: 'Categories',
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

// Created CustomContainer for icons (buttons) showed to display different food categories.
class CustomContainer extends StatelessWidget {
  final String title;
  final String imagePath;

  const CustomContainer({
    Key? key,
    required this.title,
    required this.imagePath,
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
              style: const TextStyle(fontFamily: 'OpenSans'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Deals extends StatelessWidget {
  final String title;
  final String imgPath;
  final String distance;
  final String review;
  final String price;

  const Deals({
    Key? key,
    required this.title,
    required this.imgPath,
    required this.distance,
    required this.review,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(8),
          height: 250,
          width: 180,
          decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // shadow color
                  spreadRadius: 2, // how wide the shadow spreads
                  blurRadius: 10, // blur softness
                  offset: Offset(0, 5), // x, y position of shadow
                )
              ]),
          child: Column(
            children: [
              SizedBox(
                  height: 130,
                  width: 150,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.fill,
                      ))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontFamily: 'OpenSans-Regular.ttf',
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
              Row(
                children: [
                  Text(
                    distance,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(' | '),
                  Text(review),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Spacer(),
                  HeartIconToggle()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
