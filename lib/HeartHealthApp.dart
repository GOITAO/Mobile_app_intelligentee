import 'package:flutter/material.dart';

import 'Home.dart';
import 'MaladiesInfantilesApp.dart';
import 'QuestionnaireDiabeteApp.dart';



class HeartHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santé Cardiaque',
      theme: ThemeData(primarySwatch: Colors.red),
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
    "Avez-vous des douleurs thoraciques ?",
    "Avez-vous des essoufflements ?",
    "Avez-vous des palpitations ?",
    "Avez-vous des vertiges fréquents ?",
    "Avez-vous une fatigue inhabituelle ?",
    "Avez-vous des gonflements aux jambes ?",
    "Avez-vous des antécédents familiaux de maladies cardiaques ?",
    "Fumez-vous régulièrement ?",
    "Avez-vous une hypertension artérielle ?",
    "Avez-vous un taux de cholestérol élevé ?",
  ];

  int _currentQuestionIndex = 0;
  int _ouiCount = 0;

  void _repondreOui() {
    setState(() {
      _ouiCount++;
      _nextQuestion();
    });
  }

  void _repondreNon() {
    setState(() {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    double _probability = (_ouiCount / _questions.length) * 100;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Résultat"),
          content: Text(_getDiagnosisMessage(_probability)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                _resetQuestionnaire(); // Réinitialiser le questionnaire
              },
              child: Text("Recommencer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Retour à l'accueil
              },
              child: Text("Retour à l'accueil"),
            ),
          ],
        );
      },
    );
  }

  String _getDiagnosisMessage(double probability) {
    if (probability >= 70) {
      return "Risque élevé de problèmes cardiaques. Consultez un médecin rapidement.";
    } else if (probability >= 40) {
      return "Risque modéré. Surveillez vos symptômes et consultez si nécessaire.";
    } else {
      return "Risque faible. Continuez à surveiller votre santé.";
    }
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestionIndex = 0;
      _ouiCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Santé Cardiaque'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: _repondreNon,
                    child: Text('Non'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Question ${_currentQuestionIndex + 1} sur ${_questions.length}",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

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
