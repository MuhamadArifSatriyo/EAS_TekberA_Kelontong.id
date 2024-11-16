import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class DetailBarang extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailBarang({Key? key, required this.item}) : super(key: key);

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
