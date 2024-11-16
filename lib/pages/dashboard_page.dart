import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final totalStock = itemProvider.items.fold<int>(
      0,
      (sum, item) => sum + (item.stock ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Stok Barang: $totalStock',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: itemProvider.items.length,
                itemBuilder: (context, index) {
                  final item = itemProvider.items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('Stok: ${item.stock}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
