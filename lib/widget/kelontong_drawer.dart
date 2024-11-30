import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String namaToko; // Accept store name as a parameter

  const AppDrawer({Key? key, required this.namaToko}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // 60% of screen width
      child: Drawer(
        child: Material(
          color: Colors.grey[300], // Match the background with the app theme
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero, // Remove extra margin
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('images/profile.png'), // Profile image
                    ),
                    const SizedBox(height: 10),
                    Text(
                      namaToko, // Use the dynamic store name
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
                  Navigator.pushNamed(context, '/home'); // Route to '/home'
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard'); // Route to '/dashboard'
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: const Icon(Icons.info),
                title: const Text('Tentang Kami'),
                onTap: () {
                  Navigator.pushNamed(context, '/aboutUs'); // Route to '/aboutUs'
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}