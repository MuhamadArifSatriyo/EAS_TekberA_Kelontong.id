import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _namaToko = "Toko Madura Habib"; // Default value

  @override
  void initState() {
    super.initState();
    _loadNamaToko();
  }

  Future<void> _loadNamaToko() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaToko = prefs.getString('namaToko') ?? _namaToko;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue, // Warna pertama
                  Colors.purple, // Warna kedua
                  Colors.orange, // Warna ketiga
                ],
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('images/profile.png'), // Gambar profil
                ),
                const SizedBox(height: 10),
                Text(
                  _namaToko, // Nama toko dinamis
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home'); // Rute ke '/home'
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/dashboard'); // Rute ke '/dashboard'
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Kami'),
            onTap: () {
              Navigator.pushNamed(context, '/aboutUs'); // Rute ke '/aboutUs'
            },
          ),
        ],
      ),
    );
  }
}
