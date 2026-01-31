import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/core/database/database_service.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Map medicine;
  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  late int currentQty;
  final Color navyBlue = const Color(0xFF001F3F);

  @override
  void initState() {
    super.initState();
    currentQty = widget.medicine['quantity'];
  }

  void useMedicine() async {
    if (currentQty > 0) {
      final db = await DatabaseService().db;
      int newQty = currentQty - 1;
      await db.update('medicines', {'quantity': newQty}, where: 'id = ?', whereArgs: [widget.medicine['id']]);
      setState(() => currentQty = newQty);
      Get.snackbar("تم", "تم استخدام حبة واحدة", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("تنبيه", "الكمية نفدت!", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل العلاج", style: TextStyle(color: Colors.white)), backgroundColor: navyBlue, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("الاسم: ${widget.medicine['name']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: Text("\nالكمية الحالية: $currentQty\nتاريخ الانتهاء: ${widget.medicine['expiry_date']}"),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: navyBlue, minimumSize: const Size(double.infinity, 55)),
              onPressed: useMedicine,
              icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
              label: const Text("استخدام حبة واحدة", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}