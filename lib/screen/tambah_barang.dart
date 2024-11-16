import 'package:flutter/material.dart';

class TambahBarangScreen extends StatefulWidget {
  @override
  _TambahBarangScreenState createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void saveItem() {
    final name = itemNameController.text;
    final quantity = int.tryParse(quantityController.text) ?? 0;

    if (name.isNotEmpty && quantity > 0) {
      Navigator.of(context).pop({'name': name, 'quantity': quantity});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama Barang',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Jumlah',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveItem,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
