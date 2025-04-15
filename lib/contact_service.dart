import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  final String baseUrl = "http://192.168.0.6:5000/contacts";

  // Créer un contact avec poids et âge en tant que double
  Future<Map<String, dynamic>?> createContact(double poids, double age, String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Ajouter le token JWT ici
        },
        body: jsonEncode({
          "poids": poids,
          "age": age,
        }),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return {'error': 'Erreur de connexion'};
    }
  }

  // Récupérer les contacts
  Future<Object> getContacts(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/obtenir"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Ajouter le token JWT ici
        },
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> contacts = data['contacts'] ?? [];
        return contacts.map((contact) => Map<String, dynamic>.from(contact)).toList();
      } else {
        print("Erreur API (${response.statusCode}) : ${response.body}");
        return _handleError(response);
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      return [];
    }
  }

  // Gestion des erreurs API
  Map<String, dynamic> _handleError(http.Response response) {
    try {
      final errorResponse = jsonDecode(response.body);
      print("Error Response: $errorResponse");
      return errorResponse ?? {'error': 'Erreur inconnue'};
    } catch (e) {
      print("Error parsing error response: $e");
      return {'error': 'Erreur inconnue'};
    }
  }
}
