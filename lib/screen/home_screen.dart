import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_manager/widget/kelontong_drawer.dart';
import '../screen/tambah_barang.dart';
import '../screen/detail_barang.dart';
import '../screen/profile.dart';
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
  String _namaToko = 'Toko Anda';
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

  Future<void> _loadNamaToko() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaToko = prefs.getString('namaToko') ?? 'Toko Anda';
    });
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('inventory');
    if (savedData != null) {
      setState(() {
        _inventory = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('inventory', json.encode(_inventory));
  }

  void _onEditItem(Map<String, dynamic> updatedItem) {
    setState(() {
      final index = _inventory.indexWhere((item) => item['name'] == updatedItem['name']);
      if (index != -1) {
        _inventory[index] = updatedItem;
      }
    });
    _saveInventory();
  }

  void _onDeleteItem(Map<String, dynamic> item) {
    setState(() {
      _inventory.removeWhere((existingItem) => existingItem['name'] == item['name']);
    });
    _saveInventory();
  }

  void _handleAddItem(Map<String, dynamic> newItem) {
    setState(() {
      _inventory.add({
        'name': newItem['nama'],
        'category': newItem['kategori'],
        'stock': newItem['stok'],
        'price': newItem['harga'],
        'description': newItem['deskripsi'],
        'status': _getStockStatus(newItem['stok']),
        'imagePath': newItem['imagePath'],
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

  // Fungsi untuk menangani popback dengan konfirmasi
  Future<bool> _onWillPop() async {
    // Menampilkan dialog konfirmasi ketika pengguna mencoba menekan tombol kembali
    final shouldPop = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah anda yakin untuk meninggalkan halaman ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Keluar dari halaman
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Tidak keluar
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );

    return shouldPop ?? false; // Mengembalikan nilai yang didapatkan dari dialog
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Menambahkan konfirmasi saat tombol back ditekan
      child: DefaultTabController(
        length: _categories.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.sort_rounded, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text.rich(
              TextSpan(
                text: 'Halo, ', 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                ),
                children: [
                  TextSpan(
                    text: '$_namaToko', 
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
              onTap: (index) {
                setState(() {});
              },
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
                  builder: (context) => TambahBarang(onAddItem: _handleAddItem),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
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
            const SizedBox(height: 8),
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item['category'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${item['price'].toString()}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['stock'].toString()}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(item['status']),
                  ),
                ),
                Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(item['status']),
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
