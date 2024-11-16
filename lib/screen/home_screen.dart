import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_manager/widget/kelontong_drawer.dart';
import '../screen/tambah_barang.dart';
import '../screen/detail_barang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _inventory = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _namaToko = 'Toko Anda'; // Variabel untuk menyimpan nama toko
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Makanan',
    'Sayuran',
    'Peralatan Rumah Tangga',
    'Minuman',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadInventory();
    _loadNamaToko(); // Panggil fungsi untuk memuat nama toko
  }

  // Load Nama Toko dari SharedPreferences
  Future<void> _loadNamaToko() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaToko = prefs.getString('namaToko') ?? 'Toko Anda';
    });
    debugPrint('Nama Toko yang Dimuat: $_namaToko'); // Debugging
  }

  // Load inventory dari text file
  Future<void> _loadInventory() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inventory.txt');

    if (await file.exists()) {
      final contents = await file.readAsString();
      List<dynamic> jsonData = json.decode(contents);
      setState(() {
        _inventory = List<Map<String, dynamic>>.from(jsonData);
      });
    }
  }

  // Simpan inventory ke text file
  Future<void> _saveInventory() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inventory.txt');

    String jsonData = json.encode(_inventory);
    await file.writeAsString(jsonData);
  }

  void _handleAddItem(Map<String, dynamic> itemData) {
    setState(() {
      _inventory.add({
        'name': itemData['nama'],
        'category': itemData['kategori'],
        'stock': itemData['stok'],
        'price': itemData['harga'],
        'description': itemData['deskripsi'],
        'status': _getStockStatus(itemData['stok']),
        'imagePath': itemData['imagePath'], // Tambahkan path gambar
      });
    });
    _saveInventory();
  }

  String _getStockStatus(int stock) {
    if (stock > 10) return 'Stok Aman';
    if (stock > 0) return 'Stok Menipis';
    return 'Stok Habis';
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

  // Fungsi untuk debugging SharedPreferences
  Future<void> printSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('Data SharedPreferences: ${prefs.getString('namaToko')}');
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredInventory = _inventory
        .where((item) =>
            (_selectedCategory == 'All' ||
                item['category'] == _selectedCategory) &&
            item['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'Halo, $_namaToko',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Barang',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),

            // Category Filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  icon: const Icon(Icons.category),
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
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Inventory List
            Expanded(
              child: filteredInventory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada barang',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: 0.60,
                      ),
                      itemCount: filteredInventory.length,
                      itemBuilder: (context, index) {
                        final item = filteredInventory[index];
                        return _buildItemCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahBarang(onAddItem: _handleAddItem),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail barang
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBarang(item: item),
          ),
        );
      },
      child: Container(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tambahkan Gambar
            if (item['imagePath'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                        item['imagePath'],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(item['imagePath']),
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              )
            else
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            SizedBox(height: 8),
            // Nama Barang
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            // Kategori
            Text(
              item['category'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            // Harga
            Text(
              'Rp ${item['price'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            // Status Stok
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['stock']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(item['status']),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(item['status']),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
