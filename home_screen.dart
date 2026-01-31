import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/core/database/database_service.dart';
import 'add_medicine_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'mediecine_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const MedicineListBody(),
    const ProfileScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF001F3F);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: navyBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'my_pharmacy'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'.tr),
        ],
      ),
    );
  }
}

class MedicineListBody extends StatefulWidget {
  const MedicineListBody({super.key});
  @override
  State<MedicineListBody> createState() => _MedicineListBodyState();
}

class _MedicineListBodyState extends State<MedicineListBody> {
  List medicines = [];

  void load() async {
    final data = await DatabaseService().getMedicines();
    setState(() => medicines = data);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF001F3F);
    return Scaffold(
      appBar: AppBar(
        title:  Text('my_meds'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: navyBlue,
        centerTitle: true,
      ),
      body: medicines.isEmpty
          ?  Center(child: Text('no_meds'.tr))
          : ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, i) {
          var item = medicines[i];
          int qty = item['quantity'];
          bool isLowQty = qty < 6;

          bool isNearExpiry = false;
          // --- درع الحماية لمنع الشاشة الحمراء ---
          try {
            if (item['expiry_date'] != null) {
              DateTime expiryDate = DateTime.parse(item['expiry_date'].toString().trim());
              DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              int daysLeft = expiryDate.difference(today).inDays;
              isNearExpiry = daysLeft <= 10 && daysLeft >= 0;
            }
          } catch (e) {
            // إذا كان التاريخ خطأ، سيكمل التطبيق ولن تظهر الشاشة الحمراء
            isNearExpiry = false;
          }

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: isLowQty ? Colors.red[50] : (isNearExpiry ? Colors.yellow[100] : Colors.white),
            child: ListTile(
              leading: isNearExpiry && !isLowQty
                  ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                  : const Icon(Icons.medication, color: navyBlue),
              title: Text(item['name'], style: TextStyle(color: isLowQty ? Colors.red : (isNearExpiry ? Colors.orange[900] : navyBlue), fontWeight: FontWeight.bold)),
              subtitle: Text('${'rem_qty'.tr} ${item['quantity']}'),              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final db = await DatabaseService().db;
                  await db.delete('medicines', where: 'id = ?', whereArgs: [item['id']]);
                  load();
                },
              ),
              onTap: () async {
                await Get.to(() => MedicineDetailsScreen(medicine: item));
                load();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navyBlue,
        onPressed: () async {
          var res = await Get.to(() => const AddMedicineScreen());
          if (res == true) load();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}