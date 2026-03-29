import 'package:flutter/material.dart';

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

  String? selectedRestaurant;
  String? selectedCategory;

  final List<String> restaurants = [
    'باريكيو',
    'Se7tin - صحتين',
    'ماك برجر',
    'Cafe Alenoo',
  ];
  final List<String> categories = [
    'بيتزا',
    'برجر',
    'ساندوتش',
    'مشروبات',
    'حلويات',
  ];

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
                items: restaurants,
                onChanged:
                    (value) => setState(() => selectedRestaurant = value),
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
                          (value) => setState(() => selectedCategory = value),
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
                onTap: () {
                  // TODO: Image Picker
                },
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
                  child: Column(
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
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Add item logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إضافة الصنف بنجاح')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
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
    required ValueChanged<String?> onChanged,
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
        child: DropdownButtonFormField<String>(
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
