import 'package:flutter/material.dart';
import '../screen/welcome_screen.dart';

void main() {
  runApp(exapp());
}

class exapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 106, 23, 58)),
      home: WelcomeScreen(),
    );
  }
}
