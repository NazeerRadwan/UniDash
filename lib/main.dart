/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

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

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List restaurants = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/restaurants'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          // لو API بيرجع ليست مباشرة
          restaurants = data is List ? data : data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Server Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      isLoading = true;
    });
    await fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants'), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading:
                            restaurant['image'] != null &&
                                    restaurant['image'].toString().isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    restaurant['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Icon(Icons.restaurant, size: 40),
                        title: Text(
                          restaurant['name'] ?? 'No Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          restaurant['description'] ??
                              'No Description Available',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:unidash/Screens/pizzaMenuScreen.dart';
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
        '/pizzaMenu': (context) => const PizzaMenuScreen(),
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
