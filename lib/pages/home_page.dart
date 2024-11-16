import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../widgets/item_tile.dart';
import '../widgets/add_item_dialog.dart';
import 'dashboard_page.dart';

class HomePage extends StatelessWidget {
  final String storeName;

  HomePage({required this.storeName});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat mengelola dengan riang gembira, $storeName'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(storeName, style: TextStyle(fontSize: 24)),
              decoration: BoxDecoration(color: Colors.green),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implementasi pencarian (opsional)
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itemProvider.items.length,
                itemBuilder: (context, index) {
                  return ItemTile(
                    item: itemProvider.items[index],
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddItemDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
