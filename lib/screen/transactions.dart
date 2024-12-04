import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Halaman Transaksi',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
