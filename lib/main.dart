import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/about_us_screen.dart';
import '../screen/profile.dart'; // Import halaman profil
import '../screen/transactions.dart'; // Import halaman transaksi
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String initialRoute = '/';

  try {
    // Coba membaca file profile untuk platform yang mendukung file system
    final directory = await getApplicationDocumentsDirectory();
    final profileFile = File('${directory.path}/profile.txt');

    if (await profileFile.exists()) {
      initialRoute = '/home';
    }
  } catch (e) {
    // Jika gagal (misalnya di Chrome View), fallback ke route default "/"
    print("Error accessing file systemm");
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      initialRoute: initialRoute, // Define the initial route
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome screen route
        '/home': (context) => HomeScreen(), // Home screen route
        '/dashboard': (context) => DashboardScreen(), // Dashboard screen route
        '/aboutUs': (context) => AboutUsScreen(), // AboutUs screen route
        '/profile': (context) => ProfileScreen(), // Profile screen route
        '/transactions': (context) =>
            TransactionsScreen(), // Transactions screen route
      },
    );
  }
}
