import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // سيعمل تلقائياً لتنسيق التاريخ
import 'package:untitled11/core/database/database_service.dart';
import 'package:untitled11/core/database/database_service.dart';
class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});
  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final expiryController = TextEditingController();
  final Color navyBlue = const Color(0xFF001F3F);

  // دالة تفتح التقويم وتكتب التاريخ بالشكل الصحيح تلقائياً
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // يحوله لشكل (سنة-شهر-يوم) مع الأصفار المطلوبة
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        expiryController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('add_med_title'.tr, style: TextStyle(color: Colors.white)),
        backgroundColor: navyBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration:  InputDecoration(labelText: 'med_name_label'.tr)),
            const SizedBox(height: 15),
            TextField(controller: qtyController, keyboardType: TextInputType.number, decoration:  InputDecoration(labelText: 'quantity_label'.tr)),
            const SizedBox(height: 15),

            // عند الضغط هنا يفتح التقويم
            TextField(
              controller: expiryController,
              readOnly: true, // يمنع الكتابة اليدوية لمنع الأخطاء
              onTap: _selectDate,
              decoration:  InputDecoration(
                labelText: 'expiry_date_label'.tr,
                prefixIcon: Icon(Icons.calendar_month),
                hintText: "اضغطي لاختيار التاريخ",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: navyBlue, minimumSize: const Size(double.infinity, 50)),
              onPressed: () async {
                if (nameController.text.isNotEmpty && qtyController.text.isNotEmpty && expiryController.text.isNotEmpty) {
                  final db = await DatabaseService().db;
                  await db.insert('medicines', {
                    'name': nameController.text.trim(),
                    'quantity': int.parse(qtyController.text.trim()),
                    'expiry_date': expiryController.text.trim(),
                  });
                  Get.back(result: true);
                } else {
                  Get.snackbar("تنبيه", "أكملي البيانات أولاً");
                }
              },
              child:  Text('save_button'.tr, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}