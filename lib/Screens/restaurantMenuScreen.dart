import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unidash/Screens/paymentScreen.dart';
import 'featuredRestaurantsScreen.dart';
import '../services/cartService.dart';
import 'ProfileScreen.dart';
import 'cartScreenNew.dart';
import 'adminDashboardScreen.dart';
import 'myOrdersScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<int, int> quantities = {};

  @override
  Widget build(BuildContext context) {
    final cartItems = [
      {
        'name': 'بيتزا خضروات',
        'price': '70 ج.م',
        'image': 'assets/images/Pizza.png',
      },
      {
        'name': 'فرواله',
        'price': '40 ج.م',
        'image': 'assets/images/Pizza_2.png',
      },
      {
        'name': 'باكت بطاطس',
        'price': '35 ج.م',
        'image': 'assets/images/Pizza_3.png',
      },
    ];

    // حسابات الأسعار (يمكن تعديلها لاحقاً حسب الكميات)
    final subtotal = 67.00;
    final deliveryFee = 5.00;
    final total = 72.00;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'سله التسوق',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062722),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(' أصناف '),
                  Text('3'),
                  Spacer(),
                  Text(
                    'تفاصيل الطلب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.receipt_long, size: 22, color: Color(0xFF062722)),
                ],
              ),
            ),
            Divider(color: Colors.grey, thickness: 0.6),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: cartItems.length,
                separatorBuilder:
                    (context, index) =>
                        const Divider(color: Colors.grey, thickness: 0.6),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                item['image']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 50),
                            Column(
                              children: [
                                SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F4D38),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 17,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              quantities[index] =
                                                  (quantities[index] ?? 1) + 1;
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${quantities[index] ?? 1}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 5),

                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 17,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if ((quantities[index] ?? 1) >
                                                  0) {
                                                quantities[index] =
                                                    (quantities[index] ?? 1) -
                                                    1;
                                              }
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['price']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF064C35),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (index == cartItems.length - 1) ...[
                        const Divider(color: Colors.grey, thickness: 0.6),

                        // المربع الجديد: المجموع الفرعي + رسوم التوصيل + الإجمالي
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$subtotal جنيه',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Text(
                                    'المجموع الفرعي',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$deliveryFee جنيه',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Text(
                                    'رسوم التوصيل',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$total جنيه',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F4D38),
                                    ),
                                  ),
                                  const Text(
                                    'الإجمالي',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // الأزرار (لم يتم تعديلها)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF0F4D38,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF0F4D38),
                                          width: 1.5,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        'اضافة اصناف',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0F4D38,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const PaymentScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'استكمال الطلب',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF0A4335),
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          final role =
              CartService.userRole?.toLowerCase() ??
              await CartService.loadRole() ??
              'student';
          switch (index) {
            case 0: // حسابي
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
            case 1: // طلباتي
              if (role == 'admin') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersScreen(),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const CartScreenNew(),
                  ),
                );
              }
              break;
            case 2: // الرئيسية
              if (role == 'admin') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const FeaturedRestaurantsScreen(),
                  ),
                );
              }
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }
}
