import 'package:flutter/material.dart';
import '../services/cartService.dart';
import 'featuredRestaurantsScreen.dart';
import 'adminDashboardScreen.dart';
import 'myOrdersScreen.dart';
import 'ProfileScreen.dart';
import 'cartScreenNew.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final List<CartItem> cartItems;

  const OrderTrackingScreen({
    super.key,
    this.orderId = '#034',
    this.cartItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'متابعة الطلب',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'رقم الطلب ${orderId.length > 2 ? orderId.substring(0, 2) : orderId}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.info_outline, color: Colors.grey),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الطلب - Timeline
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حالة الطلب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Timeline
                  _buildTimelineStep(
                    isActive: true,
                    isCompleted: true,
                    icon: Icons.restaurant,
                    title: 'قبول وبدء التحضير',
                    subtitle: 'يتم الآن تحضير وجبتك بكل حب',
                    buttonText: 'قيد التنفيذ',
                  ),
                  _buildTimelineConnector(),
                  _buildTimelineStep(
                    isActive: true,
                    isCompleted: false,
                    icon: Icons.delivery_dining,
                    title: 'جاهز للتسليم',
                    subtitle: 'قريباً سيكون طلبك جاهزاً للاستلام',
                  ),
                  _buildTimelineConnector(),
                  _buildTimelineStep(
                    isActive: false,
                    isCompleted: false,
                    icon: Icons.check_circle,
                    title: 'تم التسليم',
                    subtitle: 'استمتع بوجبتك الشهية',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // تفاصيل الطلب
            const Text(
              'تفاصيل الطلب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // عرض العناصر المطلوبة
            if (cartItems.isNotEmpty)
              ...cartItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // صورة الوجبة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // معلومات الوجبة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'الكمية: ${item.quantity}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'الفئة: ${item.category}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // السعر
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item.price * item.quantity} جنيه',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Text('لا توجد عناصر في الطلب')),
              ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF006400),
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

  Widget _buildTimelineStep({
    required bool isActive,
    required bool isCompleted,
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة داخل الدائرة
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? const Color(0xFF006400)
                    : isActive
                    ? const Color(0xFF006400)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),

        const SizedBox(width: 16),

        // النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], height: 1.4),
              ),
              if (buttonText != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Container(width: 3, height: 40, color: Colors.grey[300]),
    );
  }
}
