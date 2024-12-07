import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Kami'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bagian Logo dan Judul
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Kelontong.ID",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Aplikasi ini dinamakan Kelontong.ID. Nama ini mencerminkan tujuan utama aplikasi yaitu membantu pengelolaan inventaris toko kelontong kecil hingga menengah. Dengan nama yang sederhana dan relevan, aplikasi diharapkan mudah diingat oleh pengguna dan dapat dikenali sebagai solusi modern untuk manajemen toko. Kelontong.ID dirancang untuk menjadi alat pendukung operasional toko kelontong, menggantikan pencatatan manual yang sering kali memakan waktu dan rentan terhadap kesalahan. Dengan pendekatan berbasis teknologi, aplikasi ini memberikan kemudahan, efisiensi, dan akurasi dalam pengelolaan data inventaris.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tekber A DSI\nKampus ITS, Keputih, Kec. Sukolilo,\nSurabaya, Jawa Timur 60117\nkelontong.id@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Tombol Bantuan
              GestureDetector(
                onTap: () {
                  // Tambahkan navigasi untuk WhatsApp
                },
                child: Card(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Butuh bantuan? Chat kami di WhatsApp',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Link Syarat Ketentuan dan Kebijakan Privasi
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman syarat ketentuan
                },
                child: Text(
                  'Syarat Ketentuan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman kebijakan privasi
                },
                child: Text(
                  'Kebijakan Privasi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}