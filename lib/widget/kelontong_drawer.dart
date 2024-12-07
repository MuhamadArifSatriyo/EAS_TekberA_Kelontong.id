import 'dart:convert'; // Untuk base64 encoding
import 'dart:typed_data'; // Untuk manipulasi byte
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  final String namaToko; // Menerima nama toko sebagai parameter

  const AppDrawer({Key? key, required this.namaToko}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? _base64Image; // Gambar dalam base64

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Memuat gambar profil dari SharedPreferences
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _base64Image =
          prefs.getString('profileImage'); // Ambil data base64 gambar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // 60% dari lebar layar
      child: Drawer(
        child: Material(
          color: Colors.grey[300], // Sesuaikan warna dengan tema aplikasi
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero, // Hilangkan margin ekstra
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _base64Image != null
                          ? MemoryImage(
                              base64Decode(_base64Image!)) // Gunakan base64
                          : const AssetImage('images/profile.png')
                              as ImageProvider, // Gambar default
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.namaToko, // Gunakan nama toko yang dinamis
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/home'); // Route ke '/home'
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () async {
                  await Navigator.pushNamed(
                      context, '/profile'); // Route ke '/profile'
                  _loadProfileImage(); // Muat ulang gambar profil setelah kembali dari profil
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/dashboard'); // Route ke '/dashboard'
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Transaksi'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/transactions'); // Route ke '/transactions'
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.info),
                title: const Text('Tentang Kami'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/aboutUs'); // Route ke '/aboutUs'
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
