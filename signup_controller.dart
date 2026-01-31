import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/core/database/database_service.dart';
// استبدلنا استيراد الهوم باستيراد صفحة اللوجن
import 'package:untitled11/features/auth/presentation/view/login_screen.dart';

class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signup() async {
    String user = usernameController.text.trim();
    String pass = passwordController.text.trim();

    if (user.isNotEmpty && pass.isNotEmpty) {
      final db = await DatabaseService().db;

      await db.insert('users', {
        'username': user,
        'password': pass,
      });

      Get.snackbar("نجاح", "تم إنشاء الحساب! سجل دخولك الآن",
          backgroundColor: Colors.green, colorText: Colors.white);

      // التعديل هنا: ننتقل لصفحة تسجيل الدخول بدلاً من الرئيسية
      Get.offAll(() => const LoginScreen());
    } else {
      Get.snackbar("تنبيه", "يرجى ملء الحقول");
    }
  }
}