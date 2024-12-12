import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _inventory = [];
  int totalProducts = 0;
  int stockOutProducts = 0;
  int popularProducts = 0;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('inventory');
    if (savedData != null) {
      setState(() {
        _inventory = List<Map<String, dynamic>>.from(json.decode(savedData));
        _updateDashboardMetrics();
      });
    }
  }

  void _updateDashboardMetrics() {
    setState(() {
      totalProducts = _inventory.fold(
          0, (sum, item) => sum + (item['stock'] as num).toInt());
      stockOutProducts = _inventory.where((item) => item['stock'] == 0).length;
      popularProducts = _inventory.isNotEmpty ? _inventory[0]['stock'] : 0;
    });
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

              // Inventory Metrics
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildMetricCard('Total Stok Produk',
                      totalProducts.toString(), Colors.blue),
                  _buildMetricCard('Jumlah Produk Habis',
                      stockOutProducts.toString(), Colors.red),
                  _buildMetricCard('Jumlah Produk Populer',
                      popularProducts.toString(), Colors.green),
                ],
              ),
              SizedBox(height: 24),

              Text(
                'Detail Inventaris:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),

              _inventory.isEmpty
                  ? Text(
                      'Tidak ada data inventaris.',
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _inventory.length,
                      itemBuilder: (context, index) {
                        final item = _inventory[index];
                        return ListTile(
                          title: Text(item['name'] ?? 'Tidak ada nama'),
                          subtitle: Text(
                              'Kategori: ${item['category']}, Stok: ${item['stock']}'),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width > 400 ? 150 : double.infinity,
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
              textAlign: TextAlign.center,
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
    );
  }
}
