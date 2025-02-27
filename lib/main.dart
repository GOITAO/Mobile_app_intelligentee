import 'package:flutter/material.dart';
import 'Login.dart';
import 'RegisterPage.dart';

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
          seedColor: Colors.teal, // Couleur de base
          primary: Colors.teal,
          secondary: Colors.orangeAccent,
          background: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Centrer l'image horizontalement
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25), // Updated withAlpha
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'images/img.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // App description with better typography
              const Text(
                'Health Monitoring & Assistance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color.fromARGB(255, 35, 111, 252), // Couleur du texte
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Predict dermatological and chronic diseases with advanced AI.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87, // Couleur du texte
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Buttons with outlined style and arrows
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigation vers la page d'enregistrement
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromARGB(255, 35, 111, 252), width: 2),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Color.fromARGB(255, 35, 111, 252), // Couleur du texte
                        overlayColor: Color.fromARGB(255, 35, 111, 252).withOpacity(0.1), // Effet de survol
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8), // Espace entre le texte et la flèche
                          Icon(
                            Icons.arrow_forward,
                            color: Color.fromARGB(255, 35, 111, 252), // Couleur de la flèche
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigation vers la page de connexion
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: const Color.fromARGB(255, 19, 237, 154), width: 2),
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color.fromARGB(255, 19, 237, 154), // Couleur du texte
                        overlayColor: const Color.fromARGB(255, 19, 237, 154).withOpacity(0.1), // Effet de survol
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8), // Espace entre le texte et la flèche
                          Icon(
                            Icons.arrow_forward,
                            color: const Color.fromARGB(255, 19, 237, 154), // Couleur de la flèche
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Footer text
              const Text(
                '© 2025 Health App. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}