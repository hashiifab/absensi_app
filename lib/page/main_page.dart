import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absensi_flutter/page/absen/absen_page.dart';
import 'package:absensi_flutter/page/leave/leave_page.dart';
import 'package:absensi_flutter/page/history/history_page.dart';
import 'package:absensi_flutter/page/employee/employee_management_page.dart';
import 'package:absensi_flutter/page/employee/employee_data_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Absensi Karyawan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.1,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Mengurangi spacing di atas
                const SizedBox(height: 5),
                Expanded(
                  child: Column(
                    children: [
                      // Grid 2x2 untuk 4 menu pertama
                      Expanded(
                        flex: 1, // Mengurangi flex dari 2 menjadi 1
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1,
                          children: [
                            _buildMenuCard(
                              context,
                              icon: Icons.access_time,
                              label: "Absen",
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsenPage()));
                              },
                            ),
                            _buildMenuCard(
                              context,
                              icon: Icons.calendar_today,
                              label: "Cuti / Izin",
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LeavePage()));
                              },
                            ),
                            _buildMenuCard(
                              context,
                              icon: Icons.history,
                              label: "Riwayat",
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
                              },
                            ),
                            _buildMenuCard(
                              context,
                              icon: Icons.person_add,
                              label: "Employee Management",
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeManagementPage()));
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10), // Jarak yang cukup antara grid dan menu Employee Data
                      // Menu Employee Data sebagai persegi panjang dengan tinggi tetap
                      Container(
                        height: 80, // Tinggi tetap untuk menu Employee Data
                        child: _buildWideMenuCard(
                          context,
                          icon: Icons.people,
                          label: "Employee Data",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeDataPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideMenuCard(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.black87),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "INFO",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Apa Anda ingin keluar dari aplikasi?",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Batal", style: TextStyle(fontSize: 14)),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text("Ya", style: TextStyle(color: Colors.pinkAccent, fontSize: 14)),
              ),
            ],
          ),
        )) ??
        false;
  }
}
