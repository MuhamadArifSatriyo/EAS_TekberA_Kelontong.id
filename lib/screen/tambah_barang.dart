import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class TambahBarang extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;
  final Map<String, dynamic>? item;

  const TambahBarang({Key? key, required this.onAddItem, this.item}) : super(key: key);

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
      _stokController.text = _stock.toString(); // Update the controller text to reflect stock change
    });
  }

  void _decrementStock() {
    setState(() {
      if (_stock > 0) {
        _stock--;
        _stokController.text = _stock.toString(); // Update the controller text to reflect stock change
      }
    });
  }

   @override
  void initState() {
    super.initState();

    // Jika item tersedia, isi form dengan nilai awal
    if (widget.item != null) {
      _namaBarangController.text = widget.item!['nama'] ?? '';
      _selectedCategory = widget.item!['kategori'] ?? 'Makanan';
      _stock = widget.item!['stok'] ?? 0;
      _stokController.text = _stock.toString();
      _hargaController.text = widget.item!['harga']?.toString() ?? '';
      _deskripsiController.text = widget.item!['deskripsi'] ?? '';
      if (kIsWeb) {
        _webImageUrl = widget.item!['imagePath'];
      } else {
        final imagePath = widget.item!['imagePath'];
        if (imagePath != null && imagePath.isNotEmpty) {
          _imageFile = File(imagePath);
        }
      }
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final itemData = {
        'nama': _namaBarangController.text,
        'kategori': _selectedCategory,
        'stok': _stock,
        'harga': double.tryParse(_hargaController.text.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0,
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
        title: Text(widget.item == null ? 'Tambah Barang' : 'Edit Barang'),
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
                // Merged Stock input and added "Jumlah Stok" label on top
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jumlah Stok',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: _decrementStock,
                          ),
                          Container(
                            width: 80,
                            child: TextFormField(
                              controller: _stokController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jumlah Stok harus diisi';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Jumlah Stok harus berupa angka';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _stock = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
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
                ),
                const SizedBox(height: 16.0),
                // Harga input with dollar sign icon
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _hargaController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.attach_money), // Added dollar sign icon
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Harga harus diisi';
                          if (double.tryParse(value.replaceAll(RegExp('[^0-9.]'), '')) == null)
                            return 'Harga harus berupa angka';
                          return null;
                        },
                        onChanged: (value) {
                          // No currency formatting logic anymore
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildFormField(
                  label: 'Deskripsi Barang',
                  controller: _deskripsiController,
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: Text('Simpan Barang'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.green, 
                    foregroundColor: Colors.white, // Updated property name
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }// Updated property name

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label harus diisi';
        }
        return null;
      },
    );
  }
}
