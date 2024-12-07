import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaTokoController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _alamatController = TextEditingController();
  String? _base64Image; // Gambar dalam format base64
  final ImagePicker _picker = ImagePicker();

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
      _base64Image = prefs.getString('profileImage'); // Ambil base64 gambar
    });
  }

  Future<void> _updateDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('namaToko', _namaTokoController.text.trim());
    await prefs.setString('namaPemilik', _namaPemilikController.text.trim());
    await prefs.setString('alamatToko', _alamatController.text.trim());

    if (_base64Image != null) {
      await prefs.setString(
          'profileImage', _base64Image!); // Simpan gambar base64
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Ubah ke ImageSource.camera untuk kamera
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes); // Konversi ke base64
      });
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _base64Image != null
                        ? MemoryImage(base64Decode(
                            _base64Image!)) // Load gambar dari base64
                        : const AssetImage('images/profile.png')
                            as ImageProvider,
                  ),
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Ubah Gambar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle: TextStyle(color: Colors.blue.shade700),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label harus diisi";
            }
            return null;
          },
        ),
      ),
    );
  }
}