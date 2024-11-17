import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class TambahBarang extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;

  const TambahBarang({Key? key, required this.onAddItem}) : super(key: key);

  @override
  _TambahBarangState createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _selectedCategory = 'Makanan';
  int _stock = 0;
  File? _imageFile;
  String? _webImageUrl;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Makanan',
    'Sayuran',
    'Peralatan Rumah Tangga',
    'Minuman',
    'Lainnya',
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImageUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Mengunggah Gambar: $e')),
      );
    }
  }

  void _incrementStock() {
    setState(() {
      _stock++;
    });
  }

  void _decrementStock() {
    setState(() {
      if (_stock > 0) _stock--;
    });
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final itemData = {
        'nama': _namaBarangController.text,
        'kategori': _selectedCategory,
        'stok': _stock,
        'harga': double.tryParse(_hargaController.text) ?? 0.0,
        'deskripsi': _deskripsiController.text,
        'imagePath': kIsWeb ? _webImageUrl : _imageFile?.path,
      };

      widget.onAddItem(itemData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400, width: 2), // Added border
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                size: 48, // Added "+" icon
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tambah Foto Barang',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Nama Barang',
                  controller: _namaBarangController,
                  icon: Icons.inventory,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Kategori Barang',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      '$_stock',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: _decrementStock,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: Colors.green,
                          onPressed: _incrementStock,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Harga (Rp)',
                  controller: _hargaController,
                  icon: Icons.attach_money,
                  isNumber: true,
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Deskripsi Barang',
                  controller: _deskripsiController,
                  icon: Icons.description,
                  isMultiLine: true,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Simpan Barang'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
    bool isMultiLine = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          isNumber ? TextInputType.number : isMultiLine ? TextInputType.multiline : TextInputType.text,
      maxLines: isMultiLine ? null : 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label harus diisi';
        if (isNumber && double.tryParse(value) == null) return '$label harus berupa angka';
        return null;
      },
    );
  }
}
