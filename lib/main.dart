import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'screen/home_screen.dart'; // Import home screen
import 'screen/dashboard_screen.dart'; // Import dashboard screen
import 'screen/about_us_screen.dart'; // Import about us screen
import 'screen/profile.dart'; // Import profile screen
import 'screen/transactions.dart'; // Import transactions screen
import 'screen/welcome_screen.dart'; // Import welcome screen
=======
import '../screen/welcome_screen.dart';
import '../screen/home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/about_us_screen.dart';
>>>>>>> 9d4d95b333c3eb1725223089e4233f011a404d8c

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
<<<<<<< HEAD
      initialRoute: '/', // Define the initial route
=======
      initialRoute:
          '/', // Define the initial route (could be WelcomeScreen or HomeScreen)
>>>>>>> 9d4d95b333c3eb1725223089e4233f011a404d8c
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
