import 'package:flutter/material.dart';
import 'myOrdersScreen.dart';
import 'addRestaurantScreen.dart';
import 'addMenuItemScreen.dart';
import 'profileScreen.dart';
import 'featuredRestaurantsScreen.dart';
import 'cartScreenNew.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'لوحة تحكم الإدارة',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0F4D38),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // تحية الإدارة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ' 👋مرحباً بك، أحمد ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'إليك الخيارات المتاحة لإدارة المطعم',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // الخيارات الرئيسية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 1. متابعة الطلبات الواردة
                AdminOptionCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'الطلبات الواردة',
                  subtitle: 'متابعة الطلبات الجديدة للمطعم',
                  // badge: '٣ جديدة', // يمكنك ربطه بـ Stream لاحقاً
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 2. إضافة مطعم جديد
                AdminOptionCard(
                  icon: Icons.storefront_outlined,
                  title: 'إضافة مطعم جديد',
                  subtitle: 'إضافة مطعم إلى المنصة',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddRestaurantScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 3. إضافة صنف جديد
                AdminOptionCard(
                  icon: Icons.add_circle_outline,
                  title: 'إضافة صنف جديد',
                  subtitle: 'إضافة وجبة أو بيتزا جديدة للقائمة',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddMenuItemScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // ملاحظة صغيرة
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'يمكنك التحكم الكامل في المطعم والأصناف والطلبات من هنا',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar (نفس الستايل السابق - يمكنك تعديله للأدمن)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // أو غيّره حسب احتياجك
        selectedItemColor: const Color(0xFF0F4D38),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }
}

// كومبوننت كارت الخيار (قابل لإعادة الاستخدام)
class AdminOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const AdminOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // الأيقونة
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F4D38),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            const SizedBox(width: 20),

            // النصوص
            Expanded(
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0E6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 32, color: const Color(0xFF0F4D38)),
            ),

            // البادج (للطلبات فقط)
          ],
        ),
      ),
    );
  }
}
