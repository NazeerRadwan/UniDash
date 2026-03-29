import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFFF8F0,
      ), // نفس لون الخلفية الدافئ في التطبيق
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'حسابي',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // صورة البروفايل
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFFFE6D9,
                      ), // لون الدائرة البرتقالي الفاتح
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFFCC8A6A), // لون الايقونة
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // الاسم
            const Text(
              'أحمد محمد',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            // الإيميل
            const Text(
              'ahmed.m@university.edu',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // الخيارات
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // تعديل الملف الشخصي
                  _buildOptionTile(
                    title: 'تعديل الملف الشخصي',
                    icon: Icons.person_outline,
                    isRed: false,
                    onTap: () {
                      // TODO: Navigator to Edit Profile Screen
                    },
                  ),

                  const Divider(height: 1, indent: 20, endIndent: 20),

                  // تسجيل الخروج
                  _buildOptionTile(
                    title: 'تسجيل الخروج',
                    icon: Icons.logout,
                    isRed: true,
                    onTap: () {
                      // TODO: Logout logic
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('تسجيل الخروج'),
                              content: const Text(
                                'هل أنت متأكد من تسجيل الخروج؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // تنفيذ تسجيل الخروج
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'خروج',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required IconData icon,
    required bool isRed,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Icon(
        icon,
        color: isRed ? Colors.red : Colors.grey[700],
        size: 26,
      ),

      title: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isRed ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isRed ? Colors.red.withOpacity(0.1) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          isRed ? Icons.logout : Icons.person_outline,
          color: isRed ? Colors.red : const Color(0xFF0F4D38),
          size: 20,
        ),
      ),
    );
  }
}
