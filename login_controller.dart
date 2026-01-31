import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/core/database/database_service.dart';
import '../view/home_screen.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final db = await DatabaseService().db;
    final res = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [usernameController.text, passwordController.text]);

    if (res.isNotEmpty) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.snackbar("خطأ", "بيانات خاطئة");
    }
  }
}