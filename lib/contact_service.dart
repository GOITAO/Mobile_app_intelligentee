import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactService {
  final String baseUrl = "http://192.168.0.6:5000/contacts"; // URL de votre serveur

  // Créer un contact avec poids, âge et utiliser le token pour l'authentification
  Future<Map<String, dynamic>?> createContact(double poids, double age, String token) async {
    try {
      // Récupérer le token JWT depuis SharedPreferences
      String? token = await _getToken();

      if (token == null) {
        // Si le token est absent, retourner une erreur
        return {'error': 'Token non trouvé. Veuillez vous reconnecter.'};
      }

      // Créer un contact via l'API
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Ajouter le token JWT ici
        },
        body: jsonEncode({
          "poids": poids,
          "age": age,
        }),
      );

      // Afficher la réponse pour le débogage
      print("Response Body: ${response.body}");

      // Vérifier le code de statut de la réponse
      if (response.statusCode == 201) {
        // Si la création est réussie, retourner la réponse JSON
        return jsonDecode(response.body);
      } else {
        // Si l'API retourne une erreur, la gérer
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      // Si une exception se produit, la gérer
      print("Erreur de connexion : $e");
      return {'error': 'Erreur de connexion'};
    }
  }

  // Récupérer tous les contacts
  Future<Object> getContacts() async {
    try {
      // Récupérer le token JWT depuis SharedPreferences
      String? token = await _getToken();

      if (token == null) {
        // Si le token est absent, retourner une erreur
        return {'error': 'Token non trouvé. Veuillez vous reconnecter.'};
      }

      // Effectuer la requête GET pour récupérer les contacts
      final response = await http.get(
        Uri.parse("$baseUrl/obtenir"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Ajouter le token JWT ici
        },
      );

      // Afficher la réponse pour le débogage
      print("Response Body: ${response.body}");

      // Vérifier le code de statut de la réponse
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> contacts = data['contacts'] ?? [];
        return contacts.map((contact) => Map<String, dynamic>.from(contact)).toList();
      } else {
        // Si l'API retourne une erreur, la gérer
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      // Si une exception se produit, la gérer
      print("Erreur de connexion : $e");
      return [];
    }
  }

  // Récupérer le token JWT depuis SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token'); // Récupérer le token JWT
  }

  // Gestion des erreurs API
  Map<String, dynamic> _handleError(http.Response response) {
    try {
      final errorResponse = jsonDecode(response.body);
      print("Error Response: $errorResponse");
      return errorResponse ?? {'error': 'Erreur inconnue'};
    } catch (e) {
      // Gestion des erreurs de parsing de la réponse d'erreur
      print("Error parsing error response: $e");
      return {'error': 'Erreur inconnue'};
    }
  }
}
