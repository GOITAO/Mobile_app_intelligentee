import 'package:flutter/material.dart';
import 'SplashScreen.dart'; // ✅ ajoute ce fichier

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.orangeAccent,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ⬅️ SplashScreen sera la première page
    );
  }
}
