import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/about_us_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if profile.txt exists
  final directory = await getApplicationDocumentsDirectory();
  final profileFile = File('${directory.path}/profile.txt');

  runApp(MyApp(initialRoute: await profileFile.exists() ? '/home' : '/'));
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
      },
    );
  }
}