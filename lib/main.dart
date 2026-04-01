/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// ===================== LOGIN SCREEN =====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(
    text: "admin@collegecoffee.com",
  );
  final passwordController = TextEditingController(text: "admin123");
  bool isLoading = false;

  void login() async {
    setState(() => isLoading = true);

    final success = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}

// ===================== ORDERS SCREEN =====================
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    try {
      final data = await OrderService.getOrders();
      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load orders: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text("Order ID: ${order['_id']}"),
                    subtitle: Text("Total: ${order['totalPrice'] ?? 'N/A'}"),
                    onTap: () async {
                      // Show details when tapped
                      final details = await OrderService.getOrderById(
                        order['_id'],
                      );
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text("Order Details"),
                              content: Text(details.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

// ===================== AUTH SERVICE =====================
class AuthService {
  static const String baseUrl = "https://mustafahassanapi.ahmedbadawi.com/api";

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      await prefs.setString("name", data["name"]);
      return true;
    } else {
      return false;
    }
  }
}

// ===================== ORDER SERVICE =====================
class OrderService {
  static const String baseUrl = "https://mustafahassanapi.ahmedbadawi.com/api";

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<List> getOrders() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/orders"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      print("*************************************88888888888888888888**");
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load orders");
    }
  }

  static Future<Map<String, dynamic>> getOrderById(String id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/orders/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load order details");
    }
  }
}
*/

import 'package:flutter/material.dart';
import 'package:unidash/Screens/restaurantMenuScreen.dart';
import 'Screens/signIn.dart';
import 'Screens/signUp.dart';
import 'Screens/featuredRestaurantsScreen.dart';
import 'Screens/adminDashboardScreen.dart';
import 'Screens/myOrdersScreen.dart';
import 'services/cartService.dart';

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
    Future.delayed(const Duration(milliseconds: 1200), () async {
      final token = await CartService.loadToken();
      final role = await CartService.loadRole();
      if (token != null && token.isNotEmpty) {
        if (role != null && role.toLowerCase() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboardScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FeaturedRestaurantsScreen(),
            ),
          );
        }
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
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
