import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/cartService.dart';
import 'orderTrackingScreen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // جلب جميع الطلبات من API
  Future<void> fetchOrders() async {
    try {
      final token = CartService.userToken;

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = 'يجب تسجيل الدخول أولاً';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/orders/admin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> ordersList =
            data is List ? data : data['orders'] ?? [];

        setState(() {
          orders = List<Map<String, dynamic>>.from(
            ordersList.map((order) => Map<String, dynamic>.from(order as Map)),
          );
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'فشل في جلب الطلبات';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ: $e';
        isLoading = false;
      });
    }
  }

  // جلب تفاصيل طلب معين
  Future<Map<String, dynamic>?> fetchOrderDetails(String orderId) async {
    try {
      final token = CartService.userToken;

      if (token == null || token.isEmpty) return null;

      final response = await http.get(
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/orders/$orderId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching order details: $e');
      return null;
    }
  }

  String _getStatusColor(String? status) {
    if (status == null) return '0F4D38';
    if (status.toLowerCase().contains('delivered')) return '0F4D38';
    if (status.toLowerCase().contains('pending') ||
        status.toLowerCase().contains('preparing'))
      return 'FFC107';
    if (status.toLowerCase().contains('cancelled')) return 'DC3545';
    return '0F4D38';
  }

  String _formatDate(String? date) {
    if (date == null) return 'غير معروف';
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}';
    } catch (e) {
      return date;
    }
  }

  String _getOrderItems(Map<String, dynamic> order) {
    final items = order['orderItems'] as List?;
    if (items == null || items.isEmpty) return 'لا توجد عناصر';
    return items.map((item) => '${item['qty']}x ${item['name']}').join('\n');
  }

  String? _getFirstItemImage(Map<String, dynamic> order) {
    final items = order['orderItems'] as List?;
    if (items == null || items.isEmpty) return null;
    return (items[0] as Map<String, dynamic>?)?['image'] as String?;
  }

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
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          fetchOrders();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4D38),
                        ),
                        child: const Text(
                          'حاول مرة أخرى',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                : orders.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'لا توجد طلبات بعد',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final statusColorStr = _getStatusColor(order['status']);
                    final statusColor = Color(int.parse('0x$statusColorStr'));

                    return Column(
                      children: [
                        OrderCard(
                          status: order['status'] ?? 'غير معروف',
                          statusColor: statusColor,
                          restaurantName:
                              (order['restaurant']
                                  as Map<String, dynamic>?)?['name'] ??
                              'مطعم',
                          date: _formatDate(order['createdAt']),
                          items: _getOrderItems(order),
                          price: (order['itemsPrice'] ?? 0).toString(),
                          totalPrice: (order['totalPrice'] ?? 0).toString(),
                          buttonText: 'تتبع الطلب',
                          buttonColor: Colors.grey[700]!,
                          imageUrl: _getFirstItemImage(order),
                          showEyeIcon: true,
                          onButtonPressed: () async {
                            final orderId = order['_id'];
                            final details = await fetchOrderDetails(orderId);
                            if (details != null) {
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => OrderTrackingScreen(
                                          orderId: orderId,
                                          cartItems: [],
                                        ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        if (index < orders.length - 1)
                          const SizedBox(height: 16),
                      ],
                    );
                  },
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
  final String? imageUrl;
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
    this.imageUrl,
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
                      child:
                          imageUrl != null && imageUrl!.isNotEmpty
                              ? Image.network(
                                imageUrl!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      Icons.image_not_supported,
                                      size: 20,
                                      color: Colors.grey[400],
                                    ),
                              )
                              : Icon(
                                Icons.fastfood,
                                size: 20,
                                color: Colors.grey[400],
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
