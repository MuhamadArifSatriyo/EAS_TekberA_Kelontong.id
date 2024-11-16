import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Makanan';
  String _description = '';
  double? _price; // Ubah tipe dari int? ke double?
  int? _stock;
  String _unit = ''; // Tambahkan field untuk satuan

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Barang',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama barang harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Kategori Barang'),
                  value: _category,
                  items: ['Makanan', 'Minuman', 'Peralatan', 'Lainnya']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value ?? 'Makanan';
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Deskripsi Barang'),
                  onSaved: (value) {
                    _description = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi barang harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Rp',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Harga Barang'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _price = double.tryParse(
                              value ?? '0'); // Konversi ke double
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null) {
                            return 'Harga barang harus diisi dengan angka';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Jumlah Stok'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _stock = int.tryParse(value ?? '0');
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Jumlah stok harus diisi dengan angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Satuan'),
                  onSaved: (value) {
                    _unit = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Satuan harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Provider.of<ItemProvider>(context, listen: false)
                              .addItem(
                            Item(
                              name: _name,
                              category: _category,
                              description: _description,
                              price:
                                  _price ?? 0.0, // Pastikan menggunakan double
                              stock: _stock ?? 0,
                              unit: _unit, // Tambahkan satuan
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Tambahkan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
