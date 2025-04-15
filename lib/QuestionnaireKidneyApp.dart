import 'package:flutter/material.dart';

class QuestionnaireKidneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kidney Questionnaire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: QuestionnaireScreen(),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  int _yesCount = 0;
  final Color _primaryColor = Colors.teal;

  final List<String> _questions = [
    "Do you feel tired or have less energy?",
    "Do you have trouble concentrating?",
    "Do you have poor appetite?",
    "Do you have trouble sleeping?",
    "Do you have dry and itchy skin?",
    "Do you urinate more often, especially at night?",
    "Do you see blood in your urine?",
    "Do you have persistent puffiness around your eyes?",
    "Do your ankles or feet swell?",
    "Do you have muscle cramps at night?",
  ];

  void _nextQuestion(bool isYes) {
    setState(() {
      if (isYes) _yesCount++;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    double probability = (_yesCount / _questions.length) * 100;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Result"),
          content: Text(_getDiagnosisMessage(probability)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuestionnaire();
              },
              child: Text("Restart"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Back to Home"),
            ),
          ],
        );
      },
    );
  }

  String _getDiagnosisMessage(double probability) {
    if (probability >= 70) return "High risk of kidney disease. Please consult a nephrologist.";
    if (probability >= 40) return "Moderate risk. Monitor your kidney health.";
    return "Low risk. Keep hydrated and maintain a healthy diet.";
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestionIndex = 0;
      _yesCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionnaire("images/kidney.png");
  }

  Widget _buildQuestionnaire(String imagePath) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 30),
              Image.asset(imagePath, height: 100),
              const SizedBox(height: 20),
              Text(
                "Let's check your kidney health with some questions",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Question ${_currentQuestionIndex + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _questions[_currentQuestionIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              _buildAnswerButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_questions.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: _currentQuestionIndex == index ? 15 : 10,
          height: _currentQuestionIndex == index ? 15 : 10,
          decoration: BoxDecoration(
            color: _currentQuestionIndex >= index ? _primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildAnswerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnswerButton("Yes", Colors.teal, Colors.white, Icons.check, true),
        const SizedBox(width: 20),
        _buildAnswerButton("No", Colors.redAccent, Colors.white, Icons.close, false),
      ],
    );
  }

  Widget _buildAnswerButton(
      String text, Color bgColor, Color textColor, IconData icon, bool isYes) {
    return ElevatedButton.icon(
      onPressed: () => _nextQuestion(isYes),
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
