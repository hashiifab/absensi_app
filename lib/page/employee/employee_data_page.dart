import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDataPage extends StatefulWidget {
  const EmployeeDataPage({super.key});

  @override
  State<EmployeeDataPage> createState() => _EmployeeDataPageState();
}

class _EmployeeDataPageState extends State<EmployeeDataPage> {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editEmployee(String docId, String name, String employeeId, String position) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController idController = TextEditingController(text: employeeId);
    TextEditingController positionController = TextEditingController(text: position);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Data Karyawan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Nama", nameController),
            const SizedBox(height: 10),
            _buildTextField("ID Karyawan", idController),
            const SizedBox(height: 10),
            _buildTextField("Posisi", positionController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await employeeCollection.doc(docId).update({
                'name': nameController.text,
                'employee_id': idController.text,
                'position': positionController.text,
              });
              Navigator.pop(context);
              _showSnackbar("Data berhasil diperbarui", Colors.black);
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () async {
              await employeeCollection.doc(docId).delete();
              Navigator.pop(context);
              _showSnackbar("Data berhasil dihapus", Colors.black);
            },
            child: const Text("Ya", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black, // Changed to black color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Data Karyawan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: employeeCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var employees = snapshot.data!.docs;
            if (employees.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 80, color: const Color(0xFF0A1747)), // Navy blue color
                    SizedBox(height: 20),
                    Text("Belum ada data karyawan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                      "Tambahkan karyawan baru melalui menu Employee Management",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                var doc = employees[index];
                var data = doc.data() as Map<String, dynamic>;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black, // Changed to black color
                      child: Text(
                        data['name']?.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      data['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Posisi: ${data['position'] ?? '-'}"),
                        Text("ID: ${data['employee_id'] ?? '-'}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => _editEmployee(
                            doc.id,
                            data['name'] ?? '',
                            data['employee_id'] ?? '',
                            data['position'] ?? '',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _deleteEmployee(doc.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}