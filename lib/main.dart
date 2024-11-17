import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';  
import '../screen/dashboard_screen.dart'; 
import '../screen/about_us_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      initialRoute:
          '/', // Define the initial route (could be WelcomeScreen or HomeScreen)
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome screen route
        '/home': (context) => HomeScreen(), // Home screen route
        '/dashboard': (context) => DashboardScreen(), // Dashboard screen route
        '/aboutUs': (context) => AboutUsScreen(), // AboutUs screen route
      },
    );
  }
}
