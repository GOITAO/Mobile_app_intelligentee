import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl =
      "http://172.20.10.4:5000/users"; // Remplacez par l'URL de votre API

  // Inscription de l'utilisateur
  Future<Map<String, dynamic>?> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
  }

  // Connexion de l'utilisateur
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
  }
}
