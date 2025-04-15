import 'package:flutter/material.dart';

class QuestionnaireHeartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Questionnaire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
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
  final Color _primaryColor = Colors.red;

  final List<String> _questions = [
    "Do you experience chest pain or discomfort?",
    "Do you feel shortness of breath during physical activity?",
    "Do you often feel fatigue or weakness?",
    "Do you have irregular heartbeats?",
    "Do you experience swelling in feet or legs?",
    "Do you sweat excessively during light activity?",
    "Do you have high blood pressure?",
    "Do you have a family history of heart disease?",
    "Do you experience dizziness or lightheadedness?",
    "Do you smoke regularly?"
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
    if (probability >= 70) return "High risk of heart disease. Consult a cardiologist.";
    if (probability >= 40) return "Moderate risk. Monitor your symptoms closely.";
    return "Low risk. Stay active and maintain a healthy lifestyle.";
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestionIndex = 0;
      _yesCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionnaire("images/heart.png");
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
                "Let's check your heart health with some questions",
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
        _buildAnswerButton("Yes", Colors.red, Colors.white, Icons.check, true),
        const SizedBox(width: 20),
        _buildAnswerButton("No", Colors.grey, Colors.white, Icons.close, false),
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
