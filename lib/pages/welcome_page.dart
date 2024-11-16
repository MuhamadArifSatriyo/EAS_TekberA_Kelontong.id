import 'package:flutter/material.dart';
import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _addressController = TextEditingController();

  void _startApp() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            storeName: _storeNameController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TokoKu!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _storeNameController,
                    decoration: InputDecoration(labelText: 'Nama Toko'),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama Toko harus diisi' : null,
                  ),
                  TextFormField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(labelText: 'Nama Pemilik'),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama Pemilik harus diisi' : null,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Alamat Toko'),
                    validator: (value) =>
                        value!.isEmpty ? 'Alamat Toko harus diisi' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startApp,
                    child: Text('Mulai'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
