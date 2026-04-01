/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cartService.dart';

class AddMenuItemScreen extends StatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;

  String? selectedRestaurant;
  String? selectedRestaurantId;
  String? selectedCategory;

  List<Map<String, dynamic>> restaurants = [];
  List<String> categories = [];
  bool _isLoadingRestaurants = false;
  bool _isLoadingCategories = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
    }
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _isLoadingRestaurants = true;
    });

    try {
      final token = CartService.userToken;
      if (token == null) return;

      final response = await http.get(
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/restaurants'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          restaurants = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل المطاعم: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isLoadingRestaurants = false;
      });
    }
  }

  Future<void> _fetchCategories(String restaurantId) async {
    setState(() {
      _isLoadingCategories = true;
      categories = [];
      selectedCategory = null;
    });

    try {
      final token = CartService.userToken;
      if (token == null) return;

      final response = await http.get(
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/restaurants/$restaurantId/items',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Set<String> uniqueCategories = {};
        for (var item in data) {
          if (item['category'] != null) {
            uniqueCategories.add(item['category'] as String);
          }
        }
        setState(() {
          categories = uniqueCategories.toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل التصنيفات: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedRestaurantId == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المطعم والتصنيف')),
      );
      return;
    }

    double? price;
    try {
      price = double.parse(_priceController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السعر يجب أن يكون رقم صحيح')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = CartService.userToken;
      if (token == null) return;

      // تحضير البيانات
      Map<String, dynamic> data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': price, // الرقم فعلي
        'category': selectedCategory!,
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/restaurants/$selectedRestaurantId/items',
        ),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // أضف الصورة إذا موجودة
      if (_pickedImage != null) {
        final mimeType =
            _pickedImage!.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _pickedImage!.path,
            contentType: MediaType(
              mimeType.split('/')[0],
              mimeType.split('/')[1],
            ),
          ),
        );
      }

      // أضف البيانات JSON كـ field واحد
      request.fields['data'] = jsonEncode(data);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة الصنف بنجاح')));
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          selectedRestaurant = null;
          selectedRestaurantId = null;
          selectedCategory = null;
          categories = [];
          _pickedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل: ${response.statusCode} - ${response.body}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

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
        title: const Text(
          'إضافة صنف',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معلومات الصنف',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                hintText: 'اسم الصنف',
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                hintText: 'المطعم',
                value: selectedRestaurant,
                items: restaurants.map((r) => r['name'] as String).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRestaurant = value;
                    selectedRestaurantId =
                        restaurants.firstWhere(
                          (r) => r['name'] == value,
                        )['_id'];
                    selectedCategory = null;
                  });
                  if (selectedRestaurantId != null)
                    _fetchCategories(selectedRestaurantId!);
                },
                isLoading: _isLoadingRestaurants,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'اختر التصنيف',
                      value: selectedCategory,
                      items: categories,
                      onChanged:
                          (value) => setState(() => selectedCategory = value),
                      isLoading: _isLoadingCategories,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      hintText: 'السعر',
                      suffixText: 'EGP',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                hintText: 'وصف الصنف',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child:
                      _pickedImage == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'إضافة صورة',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                          : Image.file(_pickedImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitItem,
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'إضافة صنف',
                            style: TextStyle(fontSize: 18),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    String? suffixText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        suffixText: suffixText,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
    bool isLoading = false,
  }) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
          value: value,
          hint: Text(hintText),
          isExpanded: true,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cartService.dart';

class AddMenuItemScreen extends StatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;

  String? selectedRestaurant;
  String? selectedRestaurantId;
  String? selectedCategory;

  List<Map<String, dynamic>> restaurants = [];
  List<String> categories = [];
  bool _isLoadingRestaurants = false;
  bool _isLoadingCategories = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  // دالة اختيار الصورة من الجهاز
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
    }
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _isLoadingRestaurants = true;
    });

    try {
      final token = CartService.userToken;
      if (token == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول')));
        return;
      }

      final response = await http.get(
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/restaurants'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          restaurants = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل المطاعم: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isLoadingRestaurants = false;
      });
    }
  }

  Future<void> _fetchCategories(String restaurantId) async {
    setState(() {
      _isLoadingCategories = true;
      categories = [];
      selectedCategory = null;
    });

    try {
      final token = CartService.userToken;
      if (token == null) return;

      final response = await http.get(
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/restaurants/$restaurantId/items',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Set<String> uniqueCategories = {};
        for (var item in data) {
          if (item['category'] != null) {
            uniqueCategories.add(item['category'] as String);
          }
        }
        setState(() {
          categories = uniqueCategories.toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل التصنيفات: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedRestaurantId == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المطعم والتصنيف')),
      );
      return;
    }

    // Validate price
    try {
      double.parse(_priceController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السعر يجب أن يكون رقم صحيح')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = CartService.userToken;
      if (token == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول')));
        return;
      }

      // إنشاء طلب multipart/form-data
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://mustafahassanapi.ahmedbadawi.com/api/restaurants/$selectedRestaurantId/items',
        ),
      );

      // إضافة التوكن في Headers
      request.headers['Authorization'] = 'Bearer $token';

      // إضافة الحقول النصية
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      // تحويل السعر إلى number بصيغة JSON
      request.fields['price'] = jsonEncode(double.parse(_priceController.text));
      request.fields['category'] = selectedCategory!;

      // إضافة الصورة مع تحديد نوع المحتوى إذا تم اختيارها
      if (_pickedImage != null) {
        final mimeType =
            _pickedImage!.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _pickedImage!.path,
            contentType: MediaType(
              mimeType.split('/')[0],
              mimeType.split('/')[1],
            ),
          ),
        );
      }

      // إرسال الطلب
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة الصنف بنجاح')));
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          selectedRestaurant = null;
          selectedRestaurantId = null;
          selectedCategory = null;
          categories = [];
          _pickedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل: ${response.statusCode} - ${response.body}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

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
        title: const Text(
          'إضافة صنف',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان القسم
              const Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'معلومات الصنف',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.info_outline, color: Color(0xFF0F4D38)),
                ],
              ),
              const SizedBox(height: 20),

              // اسم الصنف
              _buildTextField(
                controller: _nameController,
                hintText: 'اسم الصنف',
                icon: Icons.fastfood_outlined,
              ),

              const SizedBox(height: 16),

              // المطعم
              _buildDropdownField(
                hintText: 'المطعم',
                value: selectedRestaurant,
                items: restaurants.map((r) => r['name'] as String).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRestaurant = value;
                    selectedRestaurantId =
                        restaurants.firstWhere(
                          (r) => r['name'] == value,
                        )['_id'];
                    selectedCategory = null;
                  });
                  if (selectedRestaurantId != null) {
                    _fetchCategories(selectedRestaurantId!);
                  }
                },
                isLoading: _isLoadingRestaurants,
              ),

              const SizedBox(height: 16),

              // اختيار التصنيف + السعر
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      hintText: 'اختر التصنيف',
                      value: selectedCategory,
                      items: categories,
                      onChanged:
                          selectedRestaurantId != null
                              ? (value) =>
                                  setState(() => selectedCategory = value)
                              : null,
                      isLoading: _isLoadingCategories,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      hintText: 'السعر',
                      suffixText: 'EGP',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // وصف الصنف
              _buildTextField(
                controller: _descriptionController,
                hintText: 'وصف الصنف',
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // صورة الصنف
              const Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(Icons.image_outlined, color: Color(0xFF0F4D38)),
                  SizedBox(width: 8),
                  Text(
                    'صورة الصنف',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // منطقة رفع الصورة
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child:
                      _pickedImage == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'إضافة صورة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PNG, JPG (5 أقصى 5MB)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          )
                          : Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                _pickedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Container(
                                color: Colors.black26,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 48,
                                      color: Colors.green[400],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'تم اختيار الصورة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                ),
              ),

              const SizedBox(height: 40),

              // زر إضافة الصنف
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D38),
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'إضافة صنف',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    String? suffixText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixText: suffixText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0F4D38), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
    bool isLoading = false,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                  value: value,
                  hint: Text(
                    hintText,
                    style: TextStyle(color: Colors.grey.shade500),
                    textDirection: TextDirection.rtl,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  decoration: const InputDecoration(border: InputBorder.none),
                  items:
                      items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item, textDirection: TextDirection.rtl),
                        );
                      }).toList(),
                  onChanged: onChanged,
                ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
