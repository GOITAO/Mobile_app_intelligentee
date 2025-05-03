import 'package:flutter/material.dart';
import 'Login.dart';
import 'user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _obscurePassword = true; // 👁️ pour afficher / masquer mot de passe
  String? _passwordHint;

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement')),
      );
      return;
    }

    setState(() => _isLoading = true);

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    var response = await _userService.registerUser(username, email, password);
    setState(() => _isLoading = false);

    if (response != null && response['message'] == "User created successfully!") {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Login(successMessage: "Compte créé avec succès. Connectez-vous."),
          ),
        );
      }
    } else {
      String errorMessage = response?['error'] ?? "Erreur lors de l'inscription";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: const Color(0xFF2370FC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person_add, size: 100, color: Color(0xFF2370FC)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration("Nom"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Veuillez entrer un nom'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez entrer un email';
                      if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  if (_passwordHint != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _passwordHint!,
                        style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                      ),
                    ),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration("Mot de passe").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF2370FC),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _passwordHint = value.length < 6
                            ? "Le mot de passe doit contenir au moins 6 caractères"
                            : null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez entrer un mot de passe';
                      if (value.length < 6) return 'Mot de passe trop court';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFF2370FC),
                            ),
                            child: const Text(
                              "S'inscrire",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF2370FC)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2370FC)),
      ),
    );
  }
}
