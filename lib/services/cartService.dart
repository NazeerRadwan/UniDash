class CartItem {
  final String menuItemId;
  final String name;
  final String image;
  final double price;
  final String category;
  int quantity;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    this.quantity = 1,
  });

  // تحويل إلى Map للإرسال للـ API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': quantity,
      'image': image,
      'price': price,
      'menuItem': menuItemId,
    };
  }
}

class CartService {
  static final CartService _instance = CartService._internal();
  final List<CartItem> _items = [];
  String? restaurantId;
  String? restaurantName;
  static String? userToken;

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  // تعيين بيانات المطعم
  void setRestaurant(String id, String name) {
    restaurantId = id;
    restaurantName = name;
  }

  // إضافة عنصر إلى السلة
  void addItem(CartItem item) {
    final existingItemIndex = _items.indexWhere(
      (cartItem) => cartItem.menuItemId == item.menuItemId,
    );

    if (existingItemIndex != -1) {
      // إذا كان العنصر موجوداً، زيادة الكمية
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      // إضافة العنصر الجديد
      _items.add(item);
    }
  }

  // إزالة عنصر من السلة
  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItemId == menuItemId);
  }

  // تحديث كمية عنصر
  void updateQuantity(String menuItemId, int quantity) {
    final itemIndex = _items.indexWhere(
      (item) => item.menuItemId == menuItemId,
    );
    if (itemIndex != -1) {
      if (quantity > 0) {
        _items[itemIndex].quantity = quantity;
      } else {
        _items.removeAt(itemIndex);
      }
    }
  }

  // الحصول على جميع العناصر
  List<CartItem> getItems() {
    return List.from(_items); // إرجاع نسخة من القائمة، وليس المرجع المباشر
  }

  // مسح السلة
  void clearCart() {
    _items.clear();
  }

  // حساب السعر الإجمالي للعناصر (بدون رسوم التوصيل)
  double getItemsTotal() {
    return _items.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  // عدد العناصر
  int getItemCount() {
    return _items.length;
  }

  // عدد الكميات الإجمالية
  int getTotalQuantity() {
    return _items.fold(0, (total, item) => total + item.quantity);
  }
}
