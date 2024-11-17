import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as html;
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

  // The main issue is in the _pickImage function. Replace it with this:
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
          // For web, read the file as bytes and convert to base64
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

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb) // Only show camera option for mobile
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kamera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _namaBarangController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
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

  void _incrementStock() {
    setState(() {
      _stock++;
      _stokController.text = _stock.toString();
    });
  }

  void _decrementStock() {
    setState(() {
      if (_stock > 0) {
        _stock--;
        _stokController.text = _stock.toString();
      }
    });
  }

  Widget _buildImagePreview() {
    if (kIsWeb) {
      if (_webImageUrl != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _webImageUrl!,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      if (_imageFile != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _imageFile!,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          'Tambah Foto Barang',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image Upload Section
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(height: 16.0),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 234, 234, 234),
                    border: Border.all(
                        color: const Color.fromARGB(255, 102, 99, 99)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 76, 70, 70)
                            .withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _namaBarangController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Barang',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.inventory),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama barang harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Barang',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stokController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stok Barang',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory_2),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Stok harus diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: _incrementStock,
                                color: Colors.green,
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: _decrementStock,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _hargaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga (Rp)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga harus diisi';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Harga harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _deskripsiController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Barang',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveItem,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Barang'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
