import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:untitled11/core/database/database_service.dart';

String currentUserName = ""; // مخزن الاسم

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF001F3F);
    return Scaffold(
      appBar: AppBar(
        title: Text('login_title'.tr), // العنوان المترجم
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // كود تبديل اللغة
              if (Get.locale?.languageCode == 'ar') {
                Get.updateLocale(const Locale('en', 'US'));
              } else {
                Get.updateLocale(const Locale('ar', 'SA'));
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.shield, size: 100, color: navyBlue),
              const SizedBox(height: 20),
               Text('login_title'.tr, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navyBlue)),
              const SizedBox(height: 40),
              TextField(controller: userController, decoration:  InputDecoration(labelText:  'username_hint'.tr)),
              const SizedBox(height: 20),
              TextField(controller: passController, obscureText: true, decoration:  InputDecoration(labelText: 'password_hint'.tr)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: navyBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    String user = userController.text.trim();
                    String pass = passController.text.trim();
                    if (user.isNotEmpty && pass.isNotEmpty) {
                      bool userExists = await DatabaseService().checkUser(user, pass);
                      if (userExists) {
                        currentUserName = user; // حفظ الاسم
                        Get.offAll(() => const HomeScreen());
                      } else {
                        Get.snackbar("تنبيه", "الحساب غير موجود، سجل حساب أولاً", backgroundColor: Colors.orange, colorText: Colors.white);
                      }
                    }
                  },
                  child:  Text('login_btn'.tr, style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              TextButton(onPressed: () => Get.to(() => const SignupScreen()), child:  Text('create_acc'.tr)),
            ],
          ),
        ),
      ),
    );
  }
}