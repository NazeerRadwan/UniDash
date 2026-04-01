import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurantMenuScreen.dart';
import 'cartScreenNew.dart';
import 'ProfileScreen.dart';
import 'adminDashboardScreen.dart';
import 'myOrdersScreen.dart';
import 'featuredRestaurantsScreen.dart';
import '../services/cartService.dart';

class PizzaMenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const PizzaMenuScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<PizzaMenuScreen> createState() => _PizzaMenuScreenState();
}

class _PizzaMenuScreenState extends State<PizzaMenuScreen> {
  int _selectedIndex = 2;
  List<String> categories = [];
  List<Map<String, dynamic>> menuItems = [];
  String selectedCategory = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    CartService().setRestaurant(widget.restaurantId, widget.restaurantName);
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/restaurants/${widget.restaurantId}/items',
        ),
      );
      if (response.statusCode == 200) {
        print(response.body); // طباعة الاستجابة للتحقق من البيانات
        final List<dynamic> data = json.decode(response.body);
        final items = List<Map<String, dynamic>>.from(data);

        // استخراج الفئات الفريدة من العناصر
        final uniqueCategories = <String>{};
        for (var item in items) {
          if (item['category'] != null) {
            uniqueCategories.add(item['category'].toString());
          }
        }

        setState(() {
          menuItems = items;
          categories = uniqueCategories.toList();
          if (categories.isNotEmpty) {
            selectedCategory = categories[0];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> getFilteredItems() {
    return menuItems
        .where((item) => item['category'].toString() == selectedCategory)
        .toList();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    final role =
        CartService.userRole?.toLowerCase() ??
        await CartService.loadRole() ??
        'student';

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 1:
        if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CartScreenNew()),
          );
        }
        break;
      case 2:
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF0F4D38), width: 2),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreenNew(),
                  ),
                );
              },
            ),
            const Spacer(),
            Expanded(
              child: Text(
                widget.restaurantName,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // شريط البحث
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'بحث عن صنف...',
                  hintTextDirection: TextDirection.rtl,
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // الفئات (Tabs)
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:
                    categories
                        .map(
                          (category) => _buildCategoryChip(
                            category,
                            isSelected: selectedCategory == category,
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: 12),

            // عنوان القائمة + عدد الأصناف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'قائمة $selectedCategory',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${getFilteredItems().length} أصناف',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // قائمة الأصناف
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : getFilteredItems().isEmpty
                      ? const Center(child: Text('لا توجد عناصر في هذه الفئة'))
                      : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children:
                            getFilteredItems()
                                .map(
                                  (item) => MenuItemCard(
                                    menuItemId: item['_id'] ?? '',
                                    name: item['name'] ?? 'صنف غير معروف',
                                    description: item['description'] ?? '',
                                    price: item['price']?.toString() ?? '0',
                                    imageUrl: item['image'] ?? '',
                                    category: item['category'] ?? '',
                                  ),
                                )
                                .toList(),
                      ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0F4D38),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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

  Widget _buildCategoryChip(
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor:
              isSelected ? const Color(0xFF0F4D38) : Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

// كومبوننت عنصر القائمة (Menu Item)
class MenuItemCard extends StatefulWidget {
  final String menuItemId;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String category;

  const MenuItemCard({
    super.key,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int quantity = 1;

  void _addToCart() {
    final cartItem = CartItem(
      menuItemId: widget.menuItemId,
      name: widget.name,
      image: widget.imageUrl,
      price: double.tryParse(widget.price) ?? 0.0,
      category: widget.category,
      quantity: quantity,
    );

    CartService().addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.name} تمت الإضافة للسلة'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // صورة الطبق
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                widget.imageUrl.isNotEmpty
                    ? Image.network(
                      widget.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.local_pizza,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    )
                    : Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.local_pizza,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
          ),

          const SizedBox(width: 16),

          // تفاصيل الطبق
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // صف يحتوي على السعر وزر الإضافة
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // السعر
                    Text(
                      widget.price,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F4D38),
                      ),
                    ),
                    const Spacer(),
                    // عداد الكمية
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            icon: const Icon(Icons.remove, size: 16),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add, size: 16),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // زر الإضافة
                    GestureDetector(
                      onTap: _addToCart,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F4D38),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
