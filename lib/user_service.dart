import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "http://192.168.0.14:5000/users";

  // Inscription de l'utilisateur
  Future<Map<String, dynamic>?> registerUser(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "email": email, "password": password}),
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
