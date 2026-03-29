import 'package:flutter/material.dart';
import 'restaurantMenuScreen.dart';
import 'ProfileScreen.dart';

class PizzaMenuScreen extends StatefulWidget {
  const PizzaMenuScreen({super.key});

  @override
  State<PizzaMenuScreen> createState() => _PizzaMenuScreenState();
}

class _PizzaMenuScreenState extends State<PizzaMenuScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }
    // For index 2, stay on current screen
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
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            SizedBox(width: 210),
            const Text(
              'باريكيو',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 27,
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
                children: [
                  _buildCategoryChip('كريب'),
                  _buildCategoryChip('سوشي'),
                  _buildCategoryChip('بيتزا', isSelected: true),
                  _buildCategoryChip('شاورما'),
                  _buildCategoryChip('مشويات'),
                  _buildCategoryChip('سندوتشات'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // عنوان القائمة + عدد الأصناف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: const [
                  Text(
                    'قائمة البيتزا',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '6 أصناف',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // قائمة الأصناف
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  MenuItemCard(
                    name: 'بيتزا خضروات',
                    description: 'بيتزا خضار طازجة مع صلصة موتزاريلا',
                    price: '٨٥ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/FF6347/FFFFFF?text=Pizza+Veggies',
                  ),
                  MenuItemCard(
                    name: 'مارجريتا',
                    description: 'صلصة طماطم، جبنة موتزاريلا، ريحان',
                    price: '٧٥ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/FF4500/FFFFFF?text=Margherita',
                  ),
                  MenuItemCard(
                    name: 'بيتزا دجاج',
                    description: 'قطع دجاج مشوية، صلصة باربيكيو، بصل',
                    price: '١١٠ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/FFD700/000000?text=Chicken+Pizza',
                  ),
                  MenuItemCard(
                    name: 'ميكس لحوم',
                    description: 'سجق، سلامي، لحم مفروم، زيتون',
                    price: '١٢٥ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/8B0000/FFFFFF?text=Meat+Lovers',
                  ),
                  MenuItemCard(
                    name: 'بيتزا مشروم',
                    description: 'مشروم طازج، جبنة، صلصة طماطم',
                    price: '٩٥ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/556B2F/FFFFFF?text=Mushroom+Pizza',
                  ),
                  MenuItemCard(
                    name: 'بيتزا تونة',
                    description: 'تونة، بصل، زيتون أسود، جبنة',
                    price: '١٠٠ ج.م',
                    imageUrl:
                        'https://via.placeholder.com/300x200/4682B4/FFFFFF?text=Tuna+Pizza',
                  ),
                ],
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

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
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
    );
  }
}

// كومبوننت عنصر القائمة (Menu Item)
class MenuItemCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

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
            child: Image.asset(
              'assets/images/Pizza.png',
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
            ),
          ),

          const SizedBox(width: 16),

          // تفاصيل الطبق
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
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
                    // زر الإضافة

                    // السعر
                    Text(
                      price,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F4D38),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F4D38),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
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
