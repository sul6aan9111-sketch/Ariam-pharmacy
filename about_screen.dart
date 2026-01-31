import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF001F3F);
    return Scaffold(
      appBar: AppBar(title:  Text('about_app'.tr), backgroundColor: navyBlue),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 80, color: navyBlue),
            const SizedBox(height: 20),
             Text('about_desc'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue),
            ),
            const SizedBox(height: 20),
             Text('developed_by'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
             Text('developed_by'.tr, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}