import 'package:app/Home.dart';
import 'package:flutter/material.dart';


class QuestionnaireDiabeteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire Diabète',
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
    "Avez-vous souvent soif ?",
    "Urinez-vous fréquemment ?",
    "Avez-vous une fatigue inhabituelle ?",
    "Avez-vous des troubles de la vision ?",
    "Avez-vous perdu du poids récemment sans raison ?",
    "Avez-vous des infections fréquentes ?",
    "Avez-vous des picotements ou engourdissements dans les mains ou les pieds ?",
    "Avez-vous une cicatrisation lente des plaies ?",
    "Avez-vous une peau sèche et qui démange ?",
    "Avez-vous des antécédents familiaux de diabète ?",
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
          content: Text("Probabilité de diabète : ${_probability.toStringAsFixed(2)} %"),
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
      backgroundColor: Colors.blue, // Fond bleu clair
      body: Center(
        child: Container(
          width: 300, // Largeur du contenu
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour le contenu
            borderRadius: BorderRadius.circular(10), // Bordures arrondies
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // Ombre légère
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
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations supplémentaires'),
        backgroundColor: Colors.blue[900],

      ),
      backgroundColor: Colors.blue, // Fond bleu clair
      body: Center(
        child: Container(
          width: 300, // Largeur du contenu
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour le contenu
            borderRadius: BorderRadius.circular(10), // Bordures arrondies
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // Ombre légère
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _field1Controller,
                decoration: InputDecoration(
                  labelText: 'Champ 1',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _field2Controller,
                decoration: InputDecoration(
                  labelText: 'Champ 2',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page de résultat finale
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        field1: _field1Controller.text,
                        field2: _field2Controller.text,
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
        currentIndex: 1,
        selectedItemColor: Colors.blue[900],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
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

// Page de résultat finale
class ResultPage extends StatelessWidget {
  final String field1;
  final String field2;

  ResultPage({required this.field1, required this.field2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultat Final'),
        backgroundColor: Colors.blue[900],

      ),
      backgroundColor: Colors.blue, // Fond bleu clair
      body: Center(
        child: Container(
          width: 300, // Largeur du contenu
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour le contenu
            borderRadius: BorderRadius.circular(10), // Bordures arrondies
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // Ombre légère
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
                'hhhhhhhhhhhhhhhhhhh',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Pourcentage %',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Retourner à la page d'accueil
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Recommencer'),
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

// Pages supplémentaires
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Page d\'accueil'),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Page de profil'),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text('Page d\'historique'),
      ),
    );
  }
}