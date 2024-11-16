import 'package:flutter/material.dart';
import '../screen/tambah_barang.dart'; // Import layar TambahBarangScreen
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = []; // Daftar barang

  void navigateToTambahBarang() async {
    // Navigasi ke layar tambah barang
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahBarangScreen()),
    );

    // Tambahkan barang baru jika hasil tidak null
    if (result != null) {
      setState(() {
        items.add(result); // Tambah item ke daftar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - Kelontong.ID'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Jumlah: ${item['quantity']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToTambahBarang,
        child: Icon(Icons.add),
      ),
    );
  }
}

