import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
<<<<<<< HEAD
import '../screen/home_screen.dart';  
import '../screen/dashboard_screen.dart'; 
import '../screen/about_us_screen.dart'; 
=======
import '../screen/home_screen.dart';  // Import your HomeScreen
import '../screen/dashboard_screen.dart'; // Import DashboardScreen (create if needed)
import '../screen/about_us_screen.dart'; // Import AboutUsScreen (create if needed)
>>>>>>> main

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
=======
      theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 106, 23, 58)),
>>>>>>> main
      initialRoute: '/', // Define the initial route (could be WelcomeScreen or HomeScreen)
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome screen route
        '/home': (context) => HomeScreen(), // Home screen route
        '/dashboard': (context) => DashboardScreen(), // Dashboard screen route
        '/aboutUs': (context) => AboutUsScreen(), // AboutUs screen route
      },
    );
  }
}
