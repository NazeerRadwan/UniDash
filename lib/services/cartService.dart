import 'package:shared_preferences/shared_preferences.dart';

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
  static String? userRole;

  static const String _userTokenKey = 'user_token';
  static const String _userRoleKey = 'user_role';
  static const String _restaurantIdKey = 'restaurant_id';
  static const String _restaurantNameKey = 'restaurant_name';

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  // تعيين بيانات المطعم للمستخدم الحالي
  void setRestaurant(String id, String name) {
    restaurantId = id;
    restaurantName = name;
  }

  static Future<void> saveRestaurant(String id, String name) async {
    final instance = CartService();
    instance.restaurantId = id;
    instance.restaurantName = name;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_restaurantIdKey, id);
      await prefs.setString(_restaurantNameKey, name);
    } catch (_) {
      // ignore storage errors
    }
  }

  static Future<void> loadRestaurant() async {
    final instance = CartService();
    if (instance.restaurantId != null && instance.restaurantId!.isNotEmpty)
      return;
    try {
      final prefs = await SharedPreferences.getInstance();
      instance.restaurantId = prefs.getString(_restaurantIdKey);
      instance.restaurantName = prefs.getString(_restaurantNameKey);
    } catch (_) {
      // ignore storage errors
    }
  }

  static Future<void> clearRestaurant() async {
    final instance = CartService();
    instance.restaurantId = null;
    instance.restaurantName = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_restaurantIdKey);
      await prefs.remove(_restaurantNameKey);
    } catch (_) {
      // ignore storage errors
    }
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

  // ---------------------------------------------
  // Token persistence helpers
  // ---------------------------------------------

  static Future<void> setToken(String token) async {
    userToken = token;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userTokenKey, token);
    } catch (_) {
      // ignore storage errors
    }
  }

  static Future<void> setRole(String role) async {
    userRole = role.toLowerCase();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userRoleKey, userRole!);
    } catch (_) {
      // ignore storage errors
    }
  }

  static Future<String?> loadRole() async {
    if (userRole != null && userRole!.isNotEmpty) return userRole;
    try {
      final prefs = await SharedPreferences.getInstance();
      userRole = prefs.getString(_userRoleKey);
      return userRole;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> loadToken() async {
    if (userToken != null && userToken!.isNotEmpty) {
      return userToken;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      userToken = prefs.getString(_userTokenKey);
      return userToken;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearToken() async {
    userToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userTokenKey);
    } catch (_) {
      // ignore storage errors
    }
    await clearRestaurant();
  }

  static Future<void> clearRole() async {
    userRole = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userRoleKey);
    } catch (_) {
      // ignore storage errors
    }
  }
}
