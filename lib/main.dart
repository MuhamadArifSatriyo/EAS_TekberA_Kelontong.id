import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/about_us_screen.dart';
import '../screen/profile.dart';
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
        '/': (context) => WelcomeScreen(), 
        '/home': (context) => HomeScreen(), 
        '/dashboard': (context) => DashboardScreen(), 
        '/aboutUs': (context) => AboutUsScreen(), 
        '/profile': (context) => ProfileScreen(), 
      },
    );
  }
}
