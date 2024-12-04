import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/about_us_screen.dart';
import '../screen/profile.dart'; // Import halaman profil
import '../screen/transactions.dart'; // Import halaman transaksi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      initialRoute: '/', // Define the initial route
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
