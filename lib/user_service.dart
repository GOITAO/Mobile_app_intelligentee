import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl =
      "http://192.168.1.72:5000/users"; // ⚠️ Changez l'IP en production

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
        // L'utilisateur est créé avec succès, on stocke le user_id
        final responseData = jsonDecode(response.body);
        int userId = responseData['user_id'];

        // Stocker le user_id dans les SharedPreferences
        await _saveUserId(userId);

        return responseData;
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return {'error': 'Erreur de connexion'};
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
        // Connexion réussie, on stocke le user_id
        final responseData = jsonDecode(response.body);
        int userId = responseData['user_id'];

        // Stocker le user_id dans les SharedPreferences
        await _saveUserId(userId);

        return responseData;
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return {'error': 'Erreur de connexion'};
    }
  }

  // Sauvegarder le user_id dans SharedPreferences
  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', userId); // Sauvegarder le user_id
  }

  // Récupérer le user_id depuis SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // Récupérer le user_id
  }

  // Gestion des erreurs API
  Map<String, dynamic> _handleError(http.Response response) {
    try {
      final errorResponse = jsonDecode(response.body);
      return errorResponse ?? {'error': 'Erreur inconnue'};
    } catch (e) {
      return {'error': 'Erreur inconnue'};
    }
  }
}
