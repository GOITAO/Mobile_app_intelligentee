import 'package:flutter/material.dart';
import 'contact_service.dart';

void main() {
  runApp(const MaladiesInfantilesApp());
}

class MaladiesInfantilesApp extends StatelessWidget {
  const MaladiesInfantilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maladies Infantiles',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: QuestionnairePage(),
    );
  }
}

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final List<String> _questions = [
    "L'enfant a-t-il de la fièvre ?",
    "L'enfant a-t-il une toux persistante ?",
    "L'enfant a-t-il des éruptions cutanées ?",
    "L'enfant a-t-il des difficultés à respirer ?",
    "L'enfant a-t-il des vomissements ou de la diarrhée ?",
    "L'enfant a-t-il perdu l'appétit ?",
    "L'enfant a-t-il des douleurs abdominales ?",
    "L'enfant a-t-il des maux de tête fréquents ?",
    "L'enfant a-t-il des ganglions lymphatiques enflés ?",
    "L'enfant a-t-il été en contact avec une personne malade récemment ?",
  ];

  int _currentQuestionIndex = 0;
  int _ouiCount = 0;
  int _nonCount = 0;
  double _probability = 0.0;

  void _repondreOui() {
    setState(() {
      _ouiCount++;
      _nextQuestion();
    });
  }

  void _repondreNon() {
    setState(() {
      _nonCount++;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _probability = (_ouiCount / _questions.length) * 100;

      if (_probability >= 50) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(token: "votre_token_ici"),
          ),
        );
      } else {
        _showResultDialog();
      }
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Résultat"),
          content: Text(_getDiagnosisMessage(_probability)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuestionnaire();
              },
              child: const Text("Recommencer"),
            ),
          ],
        );
      },
    );
  }

  String _getDiagnosisMessage(double probability) {
    if (probability >= 70) {
      return "Il est fort probable que l'enfant souffre d'une maladie infantile. Consultez un médecin rapidement.";
    } else if (probability >= 40) {
      return "Il y a un risque modéré que l'enfant soit malade. Surveillez les symptômes.";
    } else {
      return "Le risque de maladie infantile est faible. Continuez à surveiller l'enfant.";
    }
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestionIndex = 0;
      _ouiCount = 0;
      _nonCount = 0;
      _probability = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-consultation'), backgroundColor: Colors.blue[900]),
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_questions[_currentQuestionIndex], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(onPressed: _repondreOui, child: const Text('Oui')),
                  ElevatedButton(onPressed: _repondreNon, child: const Text('Non')),
                ],
              ),
              const SizedBox(height: 20),
              Text("Question ${_currentQuestionIndex + 1} sur ${_questions.length}", textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String token;

  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  SecondPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informations de l\'enfant'), backgroundColor: Colors.blue[900]),
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _poidsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Poids de l\'enfant (kg)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Âge de l\'enfant', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final poids = double.tryParse(_poidsController.text);
                  final age = double.tryParse(_ageController.text);

                  if (poids != null && age != null) {
                    final contactData = {
                      "poids": poids,
                      "age": age,
                    };

                    print("Données envoyées: $contactData");

                    ContactService().createContact(poids, age, token).then((response) {
                      if (response != null && response['error'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Contact créé avec succès")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur lors de la création du contact")),
                        );
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez entrer des valeurs valides")),
                    );
                  }
                },
                child: const Text('Sauvegarder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
