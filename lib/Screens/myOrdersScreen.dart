import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'طلباتي',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // الطلب الأول - تم التوصيل
            OrderCard(
              status: 'تم التوصيل',
              statusColor: const Color(0xFF0F4D38),
              restaurantName: 'باريكيو',
              date: '08:30 أكتوبر 24',
              items: '1x بيتزا خضروات (وسط)',
              price: '85',
              totalPrice: '85',
              buttonText: 'إعادة الطلب',
              buttonColor: const Color(0xFF0F4D38),
              imagePath: 'assets/images/Barq.png',
              onButtonPressed: () {},
            ),

            const SizedBox(height: 16),

            // الطلب الثاني - قيد التحضير
            OrderCard(
              status: 'قيد التحضير',
              statusColor: const Color(0xFFFFC107),
              restaurantName: 'Se7tin - صحتين',
              date: '01:15 اليوم',
              items: '2x ساندوتش دجاج زنجر',
              price: '120',
              totalPrice: '120',
              buttonText: 'تتبع الطلب',
              buttonColor: Colors.grey[700]!,
              imagePath: 'assets/images/Sehtin.png',
              showEyeIcon: true,
              onButtonPressed: () {
                // Navigator.push إلى شاشة متابعة الطلب اللي عملناها قبل كده
              },
            ),

            const SizedBox(height: 16),

            // الطلب الثالث - تم التوصيل
            OrderCard(
              status: 'تم التوصيل',
              statusColor: const Color(0xFF0F4D38),
              restaurantName: 'ماك برجر',
              date: '09:10 أكتوبر 20',
              items: '1x وجبة برجر دبل\n1x بطاطس وسط',
              price: '145',
              totalPrice: '180',
              buttonText: 'إعادة الطلب',
              buttonColor: const Color(0xFF0F4D38),
              imagePath: 'assets/images/mac.png',
              onButtonPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// كومبوننت الكارت الخاص بالطلب (قابل لإعادة الاستخدام)
class OrderCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String restaurantName;
  final String date;
  final String items;
  final String price;
  final String totalPrice;
  final String buttonText;
  final Color buttonColor;
  final String imagePath;
  final bool showEyeIcon;
  final VoidCallback onButtonPressed;

  const OrderCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.restaurantName,
    required this.date,
    required this.items,
    required this.price,
    required this.totalPrice,
    required this.buttonText,
    required this.buttonColor,
    required this.imagePath,
    this.showEyeIcon = false,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Restaurant + Image on left, Status on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Restaurant + Image on left
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[100],
                    child: ClipOval(
                      child: Image.asset(
                        imagePath,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Status Badge on right
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          // Order Items
          Row(
            children: [
              Text(items, style: const TextStyle(fontSize: 15, height: 1.5)),
              Spacer(),
              Text(
                (price).toString() + " ج.م",
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إجمالي المبلغ',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    '$totalPrice ج.م',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F4D38),
                    ),
                  ),
                ],
              ),

              // Action Button
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (buttonText == 'إعادة الطلب') ...[
                      const Icon(Icons.refresh, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showEyeIcon) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.remove_red_eye_outlined, size: 18),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
