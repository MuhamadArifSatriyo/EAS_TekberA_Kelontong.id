import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_manager/widget/kelontong_drawer.dart';
import '../screen/tambah_barang.dart';
import '../screen/detail_barang.dart';
import '../screen/profile.dart'; // Import untuk layar ProfileScreen
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
  String _searchQuery = '';
  String _namaToko = 'Toko Anda'; // Variable untuk menyimpan nama toko
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
    _loadNamaToko();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNamaToko(); // Perbarui nama toko setiap kali widget kembali aktif
  }

  // Fungsi untuk memuat nama toko dari SharedPreferences
  Future<void> _loadNamaToko() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaToko = prefs.getString('namaToko') ?? 'Toko Anda';
    });
  }

  // Fungsi untuk memuat data inventaris dari file lokal
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

  // Fungsi untuk menyimpan data inventaris ke file lokal
  Future<void> _saveInventory() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inventory.txt');

    String jsonData = json.encode(_inventory);
    await file.writeAsString(jsonData);
  }

  void _onEditItem(Map<String, dynamic> itemData) {
    setState(() {
      final index =
          _inventory.indexWhere((item) => item['name'] == itemData['name']);
      if (index != -1) {
        _inventory[index] = itemData; // Update item
      }
    });
    _saveInventory();
  }

  void _onDeleteItem(Map<String, dynamic> item) {
    setState(() {
      _inventory.removeWhere(
          (existingItem) => existingItem['name'] == item['name']); // Hapus item
    });
    _saveInventory();
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
        'imagePath': itemData['imagePath'],
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.sort_rounded, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Tetap membuka drawer
              },
            ),
          ),
          title: Text.rich(
            TextSpan(
              text: 'Halo, ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: _namaToko,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: _categories.map((category) {
              return Tab(text: category);
            }).toList(),
          ),
        ),
        drawer: AppDrawer(namaToko: _namaToko),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              Expanded(
                child: TabBarView(
                  children: _categories.map((category) {
                    List<Map<String, dynamic>> filteredInventory =
                        _inventory.where(
                      (item) {
                        return (category == 'All' ||
                                item['category'] == category) &&
                            item['name']
                                .toString()
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase());
                      },
                    ).toList();

                    return filteredInventory.isEmpty
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
                          );
                  }).toList(),
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
                builder: (context) =>
                    TambahBarang(onAddItem: _handleAddItem),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBarang(
              item: item,
              onEditItem: _onEditItem,
              onDeleteItem: _onDeleteItem,
            ),
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
              ),
            const SizedBox(height: 8.0),
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              item['category'],
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Stok: ${item['stock']}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rp${item['price'].toString()}',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
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
}
