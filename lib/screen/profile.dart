import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaTokoController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  Future<void> _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaTokoController.text = prefs.getString('namaToko') ?? '';
      _namaPemilikController.text = prefs.getString('namaPemilik') ?? '';
      _alamatController.text = prefs.getString('alamatToko') ?? '';
    });
  }

  Future<void> _updateDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('namaToko', _namaTokoController.text.trim());
    await prefs.setString('namaPemilik', _namaPemilikController.text.trim());
    await prefs.setString('alamatToko', _alamatController.text.trim());
  }

  Future<bool> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile.txt');
      final content = 'Nama Toko: ${_namaTokoController.text}\n'
          'Nama Pemilik: ${_namaPemilikController.text}\n'
          'Alamat: ${_alamatController.text}\n';

      await file.writeAsString(content);
      print("Data berhasil disimpan ke file: ${file.path}");
      return true; // Indikator sukses
    } catch (e) {
      print("Gagal menyimpan file: $e");
      return false; // Indikator gagal
    }
  }

  @override
  void dispose() {
    _namaTokoController.dispose();
    _namaPemilikController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ikon tetap back
          onPressed: () {
            Navigator.pushNamed(context, '/home'); // Navigasi ke '/home'
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
                TextButton(
                  onPressed: () {
                    // Implement image update feature if needed
                  },
                  child: const Text(
                    'Ubah Gambar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextInput(
                  controller: _namaTokoController,
                  label: "Nama Toko",
                  hint: "Masukkan nama toko",
                ),
                const SizedBox(height: 20),
                _buildTextInput(
                  controller: _namaPemilikController,
                  label: "Nama Pemilik",
                  hint: "Masukkan nama pemilik",
                ),
                const SizedBox(height: 20),
                _buildTextInput(
                  controller: _alamatController,
                  label: "Alamat",
                  hint: "Masukkan alamat",
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _updateDataToSharedPreferences();
                      await _saveToFile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil diperbarui!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label harus diisi";
        }
        return null;
      },
    );
  }
}
