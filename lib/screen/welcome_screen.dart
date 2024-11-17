import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/home_screen.dart';

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

  void _navigateToHome() async {
    if (_formKey.currentState!.validate()) {
      await _saveDataToSharedPreferences();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

=======
import '../screen/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
>>>>>>> main
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 100, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kelontong.ID",
              style: GoogleFonts.pacifico(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
<<<<<<< HEAD
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _namaTokoController,
                      decoration: InputDecoration(
                        labelText: "Nama Toko",
                        labelStyle: TextStyle(color: Colors.orangeAccent),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama Toko harus diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _namaPemilikController,
                      decoration: InputDecoration(
                        labelText: "Nama Pemilik",
                        labelStyle: TextStyle(color: Colors.orangeAccent),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama Pemilik harus diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _alamatTokoController,
                      decoration: InputDecoration(
                        labelText: "Alamat Toko",
                        labelStyle: TextStyle(color: Colors.orangeAccent),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Alamat Toko harus diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            Material(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _navigateToHome,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                    "Yuk Mulai",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
=======
            Column(
              children: [
                Text(
                  "Yuk Kelola Kelontongmu Agar Lebih Efisien dan Efektif",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 80),
                Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        "Yuk Mulai",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
>>>>>>> main
            ),
          ],
        ),
      ),
    );
  }
}
