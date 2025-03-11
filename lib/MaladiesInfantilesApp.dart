import 'package:app/Home.dart';
import 'package:flutter/material.dart';


class MaladiesInfantilesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maladies Infantiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      // Calculer la probabilité après la dernière question
      _probability = (_ouiCount / _questions.length) * 100;
      if (_probability >= 50) {
        // Naviguer vers la nouvelle page si la probabilité est >= 50%
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(),
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
          title: Text("Résultat"),
          content: Text(_getDiagnosisMessage(_probability)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuestionnaire();
              },
              child: Text("Recommencer"),
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
      appBar: AppBar(
        title: Text('Pre-consultation'),
        backgroundColor: Colors.blue[900],
      ),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _questions[_currentQuestionIndex],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _repondreOui,
                    child: Text('Oui'),
                  ),
                  ElevatedButton(
                    onPressed: _repondreNon,
                    child: Text('Non'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Question ${_currentQuestionIndex + 1} sur ${_questions.length}",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.blue[900],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
              break;
          }
        },
      ),
    );
  }
}

// Nouvelle page avec deux champs
class SecondPage extends StatelessWidget {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations supplémentaires'),
        backgroundColor: Colors.blue[900],
      ),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Âge de l\'enfant',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _symptomsController,
                decoration: InputDecoration(
                  labelText: 'Symptômes supplémentaires',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        age: _ageController.text,
                        symptoms: _symptomsController.text,
                      ),
                    ),
                  );
                },
                child: Text('Analyser'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page de résultat finale
class ResultPage extends StatelessWidget {
  final String age;
  final String symptoms;

  ResultPage({required this.age, required this.symptoms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultat Final'),
        backgroundColor: Colors.blue[900],
      ),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Résultat de l\'analyse',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Âge de l\'enfant: $age',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Symptômes: $symptoms',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Recommencer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pages supplémentaires
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil - Maladies Infantiles'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Bienvenue sur l\'application de suivi des maladies infantiles.'),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de l\'enfant'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Informations sur le profil de l\'enfant.'),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des symptômes'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Historique des symptômes et des analyses.'),
      ),
    );
  }
}