import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'Home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: const Color.fromARGB(255, 35, 111, 252), // Bleu
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ajouter une icône en haut
            const Icon(
              Icons.account_circle, // Icône de profil
              size: 100, // Taille de l'icône
              color: Color.fromARGB(255, 35, 111, 252), // Couleur de l'icône
            ),
            const SizedBox(height: 20), // Espacement après l'icône

            // Champ email
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Color.fromARGB(255, 35, 111, 252)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 35, 111, 252)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Champ mot de passe
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(color: Color.fromARGB(255, 35, 111, 252)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 35, 111, 252)),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color.fromARGB(255, 19, 237, 154), // Vert
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
}