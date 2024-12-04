import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Halaman Profil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}