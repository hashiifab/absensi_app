import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:absensi_flutter/page/employee/camera_employee_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmployeeManagementPage extends StatefulWidget {
  final XFile? image;
  
  const EmployeeManagementPage({super.key, this.image});

  @override
  State<EmployeeManagementPage> createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  XFile? _employeeImage;
  String? _imageUrl;
  bool _isUploading = false;

  // 🔥 Collection Firestore
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  @override
  void initState() {
    super.initState();
    _employeeImage = widget.image;
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    positionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ✅ Fungsi untuk menyimpan data ke Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_employeeImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Harap ambil foto karyawan terlebih dahulu", 
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      setState(() {
        _isUploading = true;
      });
      
      try {
        // Upload foto ke Firebase Storage
        String fileName = 'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref = _storage.ref().child('employee_photos').child(fileName);
        
        File imageFile = File(_employeeImage!.path);
        await ref.putFile(imageFile);
        _imageUrl = await ref.getDownloadURL();
        
        // Simpan data karyawan ke Firestore
        await employeeCollection.add({
          'name': nameController.text.trim(),
          'employee_id': idController.text.trim(),
          'position': positionController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'photo_url': _imageUrl,
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Text("Data karyawan berhasil disimpan!",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() {
          _isUploading = false;
        });
        Navigator.pop(context); // Tutup halaman setelah submit
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("Gagal menyimpan data: $e",
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumeric = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric
            ? TextInputType.number
            : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label tidak boleh kosong';
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Masukkan email yang valid';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          "Simpan Data",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Tambah Karyawan Baru",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Foto karyawan
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const CameraEmployeePage())
                            );
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _employeeImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    File(_employeeImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.camera_alt, size: 40, color: Colors.black54),
                                    SizedBox(height: 8),
                                    Text(
                                      "Ambil Foto",
                                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(nameController, "Nama Lengkap", Icons.person),
                        _buildTextField(idController, "ID Karyawan", Icons.badge, isNumeric: true),
                        _buildTextField(positionController, "Posisi", Icons.work),
                        _buildTextField(emailController, "Email", Icons.email, isEmail: true),
                        _buildTextField(phoneController, "Nomor Telepon", Icons.phone, isNumeric: true),
                        const SizedBox(height: 20),
                        _isUploading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}