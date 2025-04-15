import 'package:flutter/material.dart';
import 'Home.dart';
import 'user_service.dart'; // Import du service API

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;

  // Fonction pour gérer la connexion via l'API
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email et mot de passe requis!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var response = await _userService.loginUser(email, password);

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['user'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bienvenue ${response['user']['username']}!")),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      // Vérification plus précise des erreurs
      String errorMessage = "Erreur lors de la connexion";

      // Si l'API retourne un message d'erreur spécifique
      if (response != null && response['message'] != null) {
        errorMessage = response['message'];
      } else if (response == null) {
        // Si la réponse est nulle, cela peut être dû à un problème de réseau
        errorMessage = "Problème de connexion au serveur. Veuillez réessayer plus tard.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: const Color.fromARGB(255, 35, 111, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Color.fromARGB(255, 35, 111, 252)),
            const SizedBox(height: 20),

            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration("Email"),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration("Mot de passe"),
            ),
            const SizedBox(height: 30),

            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color.fromARGB(255, 19, 237, 154),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 35, 111, 252)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 35, 111, 252)),
      ),
    );
  }
}
