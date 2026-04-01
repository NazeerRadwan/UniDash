import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../services/cartService.dart';
import 'package:image_picker/image_picker.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;

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

  // دالة رفع المطعم
  Future<void> _submitRestaurant() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة المطعم')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = CartService.userToken;

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // إنشاء طلب multipart/form-data
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://mustafahassanapi.ahmedbadawi.com/api/restaurants'),
      );

      // إضافة التوكن في Headers
      request.headers['Authorization'] = 'Bearer $token';

      // إضافة الحقول النصية
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;

      // إضافة الصورة مع تحديد نوع المحتوى
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

      // إرسال الطلب
      final response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة المطعم بنجاح!')));
        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          _pickedImage = null;
        });
        // العودة للشاشة السابقة بعد قليل
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        // قراءة جسم الاستجابة للحصول على تفاصيل الخطأ
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل: ${response.statusCode} - $responseBody'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() {
        _isLoading = false;
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

        title: const Text(
          'إضافة مطعم',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF0F4D38),
              child: const Icon(
                Icons.restaurant,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم المطعم
              const Text(
                'اسم المطعم',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المطعم';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'قصر المشويات',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.storefront_outlined),
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
                ),
              ),

              const SizedBox(height: 24),

              // وصف المطعم
              const Text(
                'وصف المطعم',
                // textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال وصف المطعم';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '....اكتب وصفاً مميزاً للمطعم وقائمة الطعام',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
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
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 32),

              // صورة المطعم
              const Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'صورة المطعم',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.image_outlined, color: Colors.grey),
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
                      style: BorderStyle.solid,
                      width: 2,
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

              // زر إضافة المطعم للمنصة
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRestaurant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D38),
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'إضافة المطعم للمنصة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.add, color: Colors.white),
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
