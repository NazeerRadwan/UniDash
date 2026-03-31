/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

const String baseUrl = 'https://mustafahassanapi.ahmedbadawi.com/api';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RestaurantsScreen(),
    );
  }
}

////////////////////////////////////////////////////
/// 🔹 SCREEN 1: RESTAURANTS LIST
////////////////////////////////////////////////////

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurants'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("************************************************************");
        print(data);

        setState(() {
          restaurants = data is List ? data : data['data'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String? extractId(dynamic r) {
    return r['_id']; // 👈 الحل النهائي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final r = restaurants[index];
                  final id = extractId(r);

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading:
                          r['image'] != null
                              ? Image.network(
                                r['image'],
                                width: 60,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.restaurant),
                      title: Text(r['name'] ?? 'No Name'),
                      subtitle: Text(r['description'] ?? ''),
                      onTap: () {
                        if (id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid restaurant ID ❌'),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    RestaurantDetailsScreen(restaurantId: id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

////////////////////////////////////////////////////
/// 🔹 SCREEN 2: DETAILS + ITEMS
////////////////////////////////////////////////////

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId; // 👈 String بدل int

  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  Map restaurant = {};
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final restaurantResponse = await http.get(
        Uri.parse('$baseUrl/restaurants/${widget.restaurantId}'),
      );

      final itemsResponse = await http.get(
        Uri.parse('$baseUrl/restaurants/${widget.restaurantId}/items'),
      );

      if (restaurantResponse.statusCode == 200 &&
          itemsResponse.statusCode == 200) {
        final restaurantData = jsonDecode(restaurantResponse.body);
        print("************************************************************");

        print(restaurantData);
        final itemsData = jsonDecode(itemsResponse.body);
        print("************************************************************");
        print(itemsData);
        setState(() {
          restaurant =
              restaurantData is Map
                  ? restaurantData
                  : restaurantData['data'] ?? {};

          items = itemsData is List ? itemsData : itemsData['data'] ?? [];

          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant['name'] ?? 'Details')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (restaurant['image'] != null)
                      Image.network(
                        restaurant['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        restaurant['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(restaurant['description'] ?? ''),
                    ),

                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading:
                                item['image'] != null
                                    ? Image.network(item['image'], width: 50)
                                    : const Icon(Icons.fastfood),
                            title: Text(item['name'] ?? ''),
                            subtitle: Text(item['description'] ?? ''),
                            trailing: Text(
                              '${item['price'] ?? ''} EGP',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:unidash/Screens/restaurantMenuScreen.dart';
import 'Screens/signIn.dart';
import 'Screens/signUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniDash',
      theme: ThemeData(
        primaryColor: const Color(0xFF0F4D38),
        scaffoldBackgroundColor: const Color(0xFF0F4D38),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        //'/home': (context) => const HomeScreen(),
        // '/restaurantMenu': (context) => const RestaurantMenuScreen(),
        '/cart': (context) => const CartScreen(),
        // '/pizzaMenu': يتم التنقل إليه من FeaturedRestaurantsScreen مع البيانات المطلوبة
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      Navigator.pushReplacementNamed(context, '/signin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F4D38),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/Splash_logo.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 0),
              const Text(
                'UniDash',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Skip the line, save your time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 3),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String image;
  final Color backgroundColor;
  final double imageHeight;
  final String? labelTop;
  final String? labelBottom;
  final double cardHeight;
  final VoidCallback? onTap;

  const _BrandCard({
    required this.image,
    required this.backgroundColor,
    required this.imageHeight,
    this.labelTop,
    this.labelBottom,
    this.cardHeight = 180,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
            ),
            if (labelTop != null) ...[
              const SizedBox(height: 8),
              Text(
                labelTop!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
            if (labelBottom != null) ...[
              const SizedBox(height: 2),
              Text(
                labelBottom!,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
