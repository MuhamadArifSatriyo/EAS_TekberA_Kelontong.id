import 'package:flutter/material.dart';
import 'package:inventory_manager/widget/kelontong_drawer.dart';
import '../screen/tambah_barang.dart'; // Import layar TambahBarangScreen
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/kelontong_drawer.dart'; // Import the AppDrawer


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _inventory = [];
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Makanan',
    'Sayuran',
    'Peralatan Rumah Tangga',
  ];

  void _addItem(String name, String category, int stock, String status) {
    setState(() {
      _inventory.add({
        'name': name,
        'category': category,
        'stock': stock,
        'status': status,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredInventory = _selectedCategory == 'All'
        ? _inventory
        : _inventory.where((item) => item['category'] == _selectedCategory).toList();

    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer when menu is tapped
                },
              );
            },
          ),
          title: RichText(
            text: TextSpan(
              text: 'Hi, ',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Toko Murni Jaya',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      // Add logic to handle search input
                    },
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                  tabs: _categories.map((category) => Tab(text: category)).toList(),
                ),
              ],
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: _categories.map((category) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getFilteredInventory(category).isEmpty
                  ? const Center(child: Text('Belum ada barang'))
                  : GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: _getFilteredInventory(category).map((item) {
                        return _buildItemCard(
                          item['name'],
                          item['status'],
                          item['stock'],
                          Colors.green,
                        );
                      }).toList(),
                    ),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahBarang(onAddItem: _addItem),
              ),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // Helper to filter inventory by category
  List<Map<String, dynamic>> _getFilteredInventory(String category) {
    return category == 'All'
        ? _inventory
        : _inventory.where((item) => item['category'] == category).toList();
  }

  // Helper for item cards
  Widget _buildItemCard(String itemName, String status, int count, Color statusColor) {
    return Container(
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
          Text(
            itemName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
