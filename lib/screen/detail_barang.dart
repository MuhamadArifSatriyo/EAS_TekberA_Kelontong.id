import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_manager/screen/tambah_barang.dart';
import 'dart:io';

class DetailBarang extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onEditItem;
  final Function(Map<String, dynamic>) onDeleteItem;

  const DetailBarang({
    Key? key,
    required this.item,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item['name'],
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Barang
            if (item['imagePath'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                        item['imagePath'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(item['imagePath']),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 64,
                ),
              ),
            const SizedBox(height: 16),
            // Nama Barang
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Kategori
                    Text(
                      'Kategori: ${item['category']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    // Harga
                    Text(
                      'Harga: Rp ${item['price'].toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    // Stok
                    Text(
                      'Stok: ${item['stock']} (${item['status']})',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getStatusColor(item['status']),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Deskripsi
                    Text(
                      'Deskripsi:',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['description'] ?? 'Tidak ada deskripsi.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Arahkan ke halaman edit
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TambahBarang(
                                    item: item,
                                    onAddItem: (_handleAddItem) {
                                      onEditItem(item);
                                    },
                                  ),
                                )
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Barang'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Hapus Barang'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              // Konfirmasi hapus
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Barang'),
                                  content: const Text(
                                      'Apakah Anda yakin ingin menghapus barang ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Tutup dialog
                                      },
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Tutup dialog
                                        onDeleteItem(item); // Hapus barang
                                        Navigator.pop(
                                            context); // Kembali ke daftar
                                      },
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Stok Aman':
        return Colors.green;
      case 'Stok Menipis':
        return Colors.orange;
      case 'Stok Habis':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
