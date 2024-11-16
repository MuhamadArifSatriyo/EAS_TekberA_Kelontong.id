import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('images/profile.png'), // Add your image here
                ),
                SizedBox(height: 10),
                Text(
                  'Toko Madura Habib', // Store name
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/home'); // Adjust the route to '/home'
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('Tentang Kami'),
            onTap: () {
              Navigator.pushNamed(context, '/aboutUs');
            },
          ),
        ],
      ),
    );
  }
}
