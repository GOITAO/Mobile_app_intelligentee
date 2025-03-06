import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'Home.dart';
//import 'auth_service.dart'; // Assurez-vous d'avoir une classe avec loginWithGoogle et loginWithFacebook

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
              Icons.account_circle,
              size: 100,
              color: Color.fromARGB(255, 35, 111, 252),
            ),
            const SizedBox(height: 20),

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
                  backgroundColor: const Color.fromARGB(255, 19, 237, 154),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Boutons de connexion avec Google et Facebook
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    //await loginWithGoogle();
                  },
                  icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                  label: const Text("Se connecter avec Google"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    //await loginWithFacebook();
                  },
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  label: const Text("Se connecter avec Facebook"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
