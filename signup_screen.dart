import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/core/database/database_service.dart'; // تأكدي من مسار ملف قاعدة البيانات

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // تعريف المتحكمات
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // اللون الكحلي المعتمد في مشروعك
  final Color navyBlue = const Color(0xFF001F3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // هذا هو العنوان، سيبقى موجوداً ولن يختفي
        title: Text('signup_title'.tr),

        // الـ actions هي التي تضيف أزرار إضافية في الزاوية
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (Get.locale?.languageCode == 'ar') {
                Get.updateLocale(const Locale('en', 'US'));
              } else {
                Get.updateLocale(const Locale('ar', 'SA'));
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.person_add, size: 80, color: navyBlue),
              const SizedBox(height: 40),

              // حقل اسم المستخدم
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: 'choose_username'.tr,
                  prefixIcon: Icon(Icons.person, color: navyBlue),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'choose_password'.tr,
                  prefixIcon: Icon(Icons.lock, color: navyBlue),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 40),

              // زر الحفظ في قاعدة البيانات
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    String name = userController.text.trim();
                    String pass = passController.text.trim();

                    if (name.isNotEmpty && pass.isNotEmpty) {
                      // الوصول لقاعدة البيانات
                      final dbClient = await DatabaseService().db;

                      // حفظ البيانات في جدول المستخدمين
                      await dbClient.insert("users", {
                        "username": name,
                        "password": pass,
                      });

                      // إشعار بالنجاح والعودة لشاشة تسجيل الدخول
                      Get.back();
                      Get.snackbar(
                        "نجاح",
                        "تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول");
                    }
                  },
                  child:  Text('save_account'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 18)
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
    userController.dispose();
    passController.dispose();
    super.dispose();
  }
}