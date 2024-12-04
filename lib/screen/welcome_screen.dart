import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/home_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaTokoController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _alamatTokoController = TextEditingController();

  @override
  void dispose() {
    _namaTokoController.dispose();
    _namaPemilikController.dispose();
    _alamatTokoController.dispose();
    super.dispose();
  }

  Future<void> _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('namaToko', _namaTokoController.text.trim());
    await prefs.setString('namaPemilik', _namaPemilikController.text.trim());
    await prefs.setString('alamatToko', _alamatTokoController.text.trim());
  }

  Future<void> _saveDataToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final profileFile = File('${directory.path}/profile.txt');
    final profileData = '''
    Nama Toko: ${_namaTokoController.text.trim()}
    Nama Pemilik: ${_namaPemilikController.text.trim()}
    Alamat Toko: ${_alamatTokoController.text.trim()}
    ''';
    await profileFile.writeAsString(profileData);
  }

  void _navigateToHome() async {
    if (_formKey.currentState!.validate()) {
      await _saveDataToSharedPreferences();
      await _saveDataToFile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Kelontong.ID",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Container(
                    width: 300, // Reduced width for input boxes
                    child: Column(
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
                          controller: _alamatTokoController,
                          label: "Alamat Toko",
                          hint: "Masukkan alamat toko",
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _navigateToHome,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Mulai Sekarang",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
