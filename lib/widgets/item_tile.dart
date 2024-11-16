import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import '../dialogs/edit_item_dialog.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({Key? key, required this.item}) : super(key: key);

  void _editItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditItemDialog(
        item: item, // Barang yang akan diedit
        onSave: (updatedItem) {
          Provider.of<ItemProvider>(context, listen: false)
              .updateItem(updatedItem);
        },
      ),
    );
  }

  void _deleteItem(BuildContext context) {
    Provider.of<ItemProvider>(context, listen: false).removeItem(
      Provider.of<ItemProvider>(context, listen: false).items.indexOf(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Kategori: ${item.category} | Stok: ${item.stock}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Edit') {
              _editItem(context);
            } else if (value == 'Hapus') {
              _deleteItem(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'Edit', child: Text('Edit')),
            PopupMenuItem(value: 'Hapus', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
