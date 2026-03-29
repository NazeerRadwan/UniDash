import 'package:flutter/material.dart';
import 'pizzaMenuScreen.dart';
import 'restaurantMenuScreen.dart';
import 'adminDashboardScreen.dart';

class FeaturedRestaurantsScreen extends StatelessWidget {
  final String role;

  const FeaturedRestaurantsScreen({super.key, this.role = 'student'});

  @override
  Widget build(BuildContext context) {
    // التحقق من الدور والتوجيه
    if (role.toLowerCase() == 'admin') {
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              const SizedBox(width: 172),
              const Text(
                'اهلا بك احمد',
                style: TextStyle(
                  color: Color(0xFF0A4335),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/Overlay.png'),
          ),

          //const SizedBox(width: 8),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            // عنوان المطاعم المميزة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'المطاعم المميزة',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // قائمة المطاعم
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  RestaurantCard(
                    imageUrl: 'assets/images/Resturant.png',
                    name: 'BBQ House',
                    description: 'مشويات طازجة ومميزة على الشواية',
                    tag: 'طلب الآن',
                  ),
                  SizedBox(height: 16),
                  RestaurantCard(
                    imageUrl: 'assets/images/Resturant.png',
                    name: 'Cafe Alenoo',
                    description: 'أجود أنواع القهوة المختصة والحلويات',
                    tag: 'طلب الآن',
                  ),
                  SizedBox(height: 16),
                  RestaurantCard(
                    imageUrl: 'assets/images/Resturant.png',
                    name: 'Se7tin | صحتين',
                    description: 'ماكولات صحية وعالمية بنكهة عربية',
                    tag: 'طلب الآن',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // الصفحة الحالية (الرئيسية)
        selectedItemColor: const Color(0xFF0A4335),
        unselectedItemColor: Colors.grey,
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

// كومبوننت الكارت الخاص بالمطعم
class RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String tag;

  const RestaurantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PizzaMenuScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة المطعم
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // زر "طلب الآن" على اليسار
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A4335),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // اسم ووصف المطعم على اليمين
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // اسم المطعم
                          Text(
                            name,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // وصف المطعم
                          Text(
                            description,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
