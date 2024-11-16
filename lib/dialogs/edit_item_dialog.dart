import 'package:flutter/material.dart';
import '../models/item.dart';

class EditItemDialog extends StatefulWidget {
  final Item item; // Barang yang akan diedit
  final Function(Item updatedItem) onSave; // Callback untuk menyimpan perubahan

  const EditItemDialog({
    Key? key,
    required this.item,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi controller dengan data barang
    _nameController = TextEditingController(text: widget.item.name);
    _categoryController = TextEditingController(text: widget.item.category);
    _descriptionController =
        TextEditingController(text: widget.item.description);
    _priceController =
        TextEditingController(text: widget.item.price.toString());
    _stockController =
        TextEditingController(text: widget.item.stock.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Barang'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Kategori Barang'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Barang'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga Barang'),
            ),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Stok'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            // Membuat objek Item yang diperbarui
            final updatedItem = Item(
              name: _nameController.text,
              category: _categoryController.text,
              description: _descriptionController.text,
              price: double.tryParse(_priceController.text) ?? 0.0,
              stock: int.tryParse(_stockController.text) ?? 0,
            );

            widget.onSave(updatedItem); // Panggil callback onSave
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
