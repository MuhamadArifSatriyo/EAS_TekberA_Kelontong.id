import 'package:flutter/material.dart';
import 'package:inventory_manager/widget/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State untuk nilai data
  int totalProducts = 1250;
  int stockOutProducts = 45;
  int popularProducts = 120;

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

              // Inventory Metrics Section
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  double cardWidth = constraints.maxWidth / crossAxisCount - 16;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      MetricCard(
                        title: 'Total Produk',
                        value: totalProducts.toString(),
                        color: Colors.blue,
                        width: cardWidth,
                        onTap: () => _showInputDialog(
                          'Total Produk',
                          'Jumlah Produk',
                          totalProducts,
                          (newValue) {
                            setState(() {
                              totalProducts = newValue;
                            });
                          },
                        ),
                      ),
                      MetricCard(
                        title: 'Jumlah Stok Habis',
                        value: stockOutProducts.toString(),
                        color: Colors.red,
                        width: cardWidth,
                        onTap: () => _showInputDialog(
                          'Jumlah Stok Habis',
                          'Jumlah Stok',
                          stockOutProducts,
                          (newValue) {
                            setState(() {
                              stockOutProducts = newValue;
                            });
                          },
                        ),
                      ),
                      MetricCard(
                        title: 'Jumlah Produk Populer',
                        value: popularProducts.toString(),
                        color: Colors.green,
                        width: cardWidth,
                        onTap: () => _showInputDialog(
                          'Jumlah Produk Populer',
                          'Jumlah Produk',
                          popularProducts,
                          (newValue) {
                            setState(() {
                              popularProducts = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 24),

              // Placeholder for a chart or graph
              Text(
                'Trend Stok Produk:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Placeholder Grafik Stok',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
