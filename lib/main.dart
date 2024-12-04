import 'package:flutter/material.dart';
import 'screen/home_screen.dart'; // Import home screen
import 'screen/dashboard_screen.dart'; // Import dashboard screen
import 'screen/about_us_screen.dart'; // Import about us screen
import 'screen/profile.dart'; // Import profile screen
import 'screen/transactions.dart'; // Import transactions screen
import 'screen/welcome_screen.dart'; // Import welcome screen

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
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/aboutUs': (context) => AboutUsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/transactions': (context) => TransactionsScreen(),
      },
    );
  }
}
