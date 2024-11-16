import 'package:flutter/material.dart';

class TambahBarang extends StatefulWidget {
  final Function(String, String, int, String) onAddItem;

  const TambahBarang({Key? key, required this.onAddItem}) : super(key: key);

  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  final _namaBarangController = TextEditingController();
  final _stokController = TextEditingController();
  String _selectedCategory = 'Makanan';

  final List<String> _categories = [
    'Makanan',
    'Sayuran',
    'Peralatan Rumah Tangga',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Barang
            TextField(
              controller: _namaBarangController,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Kategori Barang
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Kategori Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Stok Barang
            TextField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stok Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Tombol Tambah Barang
            ElevatedButton(
              onPressed: () {
                if (_namaBarangController.text.isNotEmpty &&
                    _stokController.text.isNotEmpty) {
                  widget.onAddItem(
                    _namaBarangController.text,
                    _selectedCategory,
                    int.parse(_stokController.text),
                    'Stok Aman',
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah Barang'),
            ),
          ],
        ),
      ),
    );
  }
}
