import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr), // سيترجم العنوان تلقائياً
        centerTitle: true,
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // معلومات المستخدم (مثال)
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF001F3F),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),

          // زر تغيير اللغة (الذي أضفناه الآن)
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF001F3F)),
              title: Text('change_lang'.tr), // هذا النص سيتغير عند الضغط
              trailing: const Icon(Icons.swap_horiz),
              onTap: () {
                // منطق تبديل اللغة
                if (Get.locale?.languageCode == 'ar') {
                  Get.updateLocale(const Locale('en'));
                } else {
                  Get.updateLocale(const Locale('ar'));
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          // زر تسجيل الخروج
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('logout'.tr),
              onTap: () {
                Get.offAll(() => LoginScreen());
                // كود تسجيل الخروج الخاص بكِ
              },
            ),
          ),
        ],
      ),
    );
  }
}

