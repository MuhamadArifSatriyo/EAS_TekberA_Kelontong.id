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
  String _namaToko = 'Toko Anda';
  List<Map<String, dynamic>> _inventory = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _categories = ['All', 'Makanan', 'Minuman'];

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
      final index = _inventory.indexWhere((item) => item['id'] == updatedItem['id']);
      if (index != -1) {
        _inventory[index] = updatedItem;
      }
    });
    _saveInventory();
  }

  void _onDeleteItem(Map<String, dynamic> item) {
    setState(() {
      _inventory.removeWhere((existingItem) => existingItem['id'] == item['id']);
    });
    _saveInventory();
  }

  void _handleAddItem(Map<String, dynamic> newItem) {
    setState(() {
      _inventory.add({
        'id': (_inventory.length + 1).toString(),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item['imagePath'] != null
                  ? kIsWeb
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
                        )
                  : Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            // Product Name
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            // Product Category
            Text(
              item['category'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            // Product Stock Status
            Row(
              children: [
                Text(
                  item['status'],
                  style: TextStyle(
                    color: _getStatusColor(item['status']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Product Price
                Text(
                  'Rp ${item['price']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
