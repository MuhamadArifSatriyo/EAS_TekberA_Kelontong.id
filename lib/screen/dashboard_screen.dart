import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State untuk nilai data
  int totalProducts = 1250;
  int stockOutProducts = 45;
  int popularProducts = 120;
  File? _imageFile; // Untuk Android/iOS
  String? _webImageUrl; // Untuk Web
  final ImagePicker _picker = ImagePicker();

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
          // Untuk platform Web, gunakan Base64 string
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImageUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          });
        } else {
          // Untuk Android/iOS, gunakan File
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

  // Fungsi untuk membuka dialog dan mengupdate data
  void _showInputDialog(String title, String metric, int currentValue, Function(int) onSave) {
    final TextEditingController controller = TextEditingController();
    controller.text = currentValue.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '$metric (Saat ini: $currentValue)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update data saat tombol "Simpan" ditekan
                final newValue = int.tryParse(controller.text) ?? currentValue;
                onSave(newValue);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header
              Text(
                'Selamat Datang di Dashboard Inventaris Produk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Berikut adalah ringkasan data inventaris produk toko:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              // Inventory Metrics (Responsive menggunakan Wrap)
              Wrap(
                spacing: 16, // Jarak horizontal antar kotak
                runSpacing: 16, // Jarak vertikal antar baris
                alignment: WrapAlignment.center,
                children: [
                  _buildMetricCard('Total Produk', totalProducts.toString(), Colors.blue, () {
                    _showInputDialog('Total Produk', 'Total Produk', totalProducts,
                        (newValue) => setState(() => totalProducts = newValue));
                  }),
                  _buildMetricCard('Jumlah Stok Habis', stockOutProducts.toString(), Colors.red, () {
                    _showInputDialog('Jumlah Stok Habis', 'Stok Habis', stockOutProducts,
                        (newValue) => setState(() => stockOutProducts = newValue));
                  }),
                  _buildMetricCard('Jumlah Produk Populer', popularProducts.toString(), Colors.green, () {
                    _showInputDialog('Jumlah Produk Populer', 'Produk Populer', popularProducts,
                        (newValue) => setState(() => popularProducts = newValue));
                  }),
                ],
              ),
              SizedBox(height: 24),

              // Placeholder Grafik Diganti dengan Image Picker
              Text(
                'Trend Stok Produk:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile == null && _webImageUrl == null
                      ? Center(
                          child: Text(
                            'Klik untuk mengunggah gambar',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  _webImageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width > 400 ? 150 : double.infinity, // Responsif
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center, // Teks rata tengah
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}