import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'orderTrackingScreen.dart';
import '../services/cartService.dart';

class PaymentScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const PaymentScreen({
    super.key,
    this.subtotal = 0.0,
    this.deliveryFee = 5.0,
    this.total = 0.0,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = 'cash';
  final notesController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: const Text(
            'طريقة الدفع',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color(0xFF0F4D38),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Container(
              //width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFC2E96A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  //SizedBox(width: 8),
                  Text(
                    'المبلغ المستحق للدفع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F4D38),
                    ),
                  ),

                  Text(
                    '145 ج.م',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F4D38),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اختر طريقة الدفع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPayment = 'cash';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedPayment == 'cash'
                        ? const Color(0xFF0F4D38)
                        : const Color(0xFFA3B18A),
                foregroundColor:
                    selectedPayment == 'cash' ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.ltr,
                children: [
                  const Text('الدفع النقدي', style: TextStyle(fontSize: 19)),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/EUR.png', width: 24, height: 24),
                  const SizedBox(width: 18),
                ],
              ),
            ),
            const SizedBox(height: 33),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPayment = 'wallet';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedPayment == 'wallet'
                        ? const Color(0xFF0F4D38)
                        : const Color(0xFFA3B18A),
                foregroundColor:
                    selectedPayment == 'wallet' ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.ltr,
                children: [
                  const Text('محفظة الكترونية', style: TextStyle(fontSize: 19)),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/Bocket.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ملاحظات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              textAlign: TextAlign.right,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ملاحظات',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            //const Spacer(),
            SizedBox(height: 74),
            Center(
              child: SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D38),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(
                        color: Color(0xFF0F4D38),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: isLoading ? null : _submitOrder,
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'تأكيد الطلب',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    final cartService = CartService();
    final cartItems = cartService.getItems();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('السلة فارغة')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = CartService.userToken;

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
        setState(() {
          isLoading = false;
        });
        return;
      }

      final orderItems = cartItems.map((item) => item.toJson()).toList();

      final orderData = {
        'restaurant': cartService.restaurantId,
        'orderItems': orderItems,
        'paymentMethod': selectedPayment,
        'itemsPrice': widget.subtotal,
        'deliveryFee': widget.deliveryFee,
        'totalPrice': widget.total,
        'notes': notesController.text,
      };

      final response = await http.post(
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("*************************************88888888888888888888**");
        print(jsonDecode(response.body));
        final responseData = json.decode(response.body);
        final orderId = responseData['_id'] ?? responseData['id'] ?? '#034';

        cartService.clearCart();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    OrderTrackingScreen(orderId: orderId, cartItems: cartItems),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إنشاء الطلب: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
