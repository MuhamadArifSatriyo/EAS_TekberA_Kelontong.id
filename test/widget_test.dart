import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inventory_manager/main.dart'; // Pastikan import path sesuai dengan aplikasi Anda

void main() {
  testWidgets('Adding, editing, and deleting items from inventory', (WidgetTester tester) async {
    // Membuat aplikasi dan memulai frame
    await tester.pumpWidget(MyApp());

    // Mengisi nama item dan quantity untuk ditambahkan ke inventaris
    final nameField = find.byType(TextField).at(0); // Menemukan TextField untuk nama item
    final quantityField = find.byType(TextField).at(1); // Menemukan TextField untuk quantity

    // Memastikan field kosong saat pertama kali
    expect(find.text('Item Name'), findsOneWidget);
    expect(find.text('Quantity'), findsOneWidget);
    expect(find.text('Item 1'), findsNothing);

    // Menambahkan item pertama
    await tester.enterText(nameField, 'Item 1');
    await tester.enterText(quantityField, '10');
    await tester.tap(find.text('Add Item')); // Menemukan tombol dan mengetuknya
    await tester.pump(); // Memicu tampilan ulang

    // Memastikan bahwa item ditambahkan ke inventaris
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Quantity: 10'), findsOneWidget);

    // Mengedit item yang sudah ada
    await tester.tap(find.byType(ListTile).first); // Mengetuk item pertama
    await tester.pump();

    // Mengubah nama item dan quantity
    await tester.enterText(nameField, 'Item 1 Edited');
    await tester.enterText(quantityField, '15');
    await tester.tap(find.text('Add Item')); // Mengetuk untuk memperbarui item
    await tester.pump(); // Memicu tampilan ulang

    // Memastikan bahwa item sudah diperbarui
    expect(find.text('Item 1 Edited'), findsOneWidget);
    expect(find.text('Quantity: 15'), findsOneWidget);

    // Menghapus item
    await tester.tap(find.byIcon(Icons.delete).first); // Mengetuk tombol hapus di item pertama
    await tester.pump(); // Memicu tampilan ulang

    // Memastikan bahwa item sudah dihapus
    expect(find.text('Item 1 Edited'), findsNothing);
    expect(find.text('Quantity: 15'), findsNothing);
  });
}
