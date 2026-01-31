import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/splash/splash_screen.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'translations.dart'; // استيراد ملف اللغات
// السطر القادم هو الأهم، تأكدي أنه يطابق مسار ملفكِ


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: MyTranslations(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
      // هنا السر! أرجعي شاشة البداية مكان الـ Login
      home: const SplashScreen(),
    );
  }
}