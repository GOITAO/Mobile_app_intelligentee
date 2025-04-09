import 'package:flutter/material.dart';

class QuestionnaireDiabeteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Questionnaire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final Color _primaryColor = Color.fromARGB(255, 35, 111, 252);

  final List<String> _questions = [
    "Do you experience frequent thirst?",
    "Do you feel excessive hunger?",
    "Do you have frequent urination?",
    "Do you experience sudden weight loss?",
    "Do you feel tired all the time?",
    "Do you have blurry vision?",
    "Do you heal wounds slowly?",
    "Do you often have dry skin?",
    "Do you have tingling or numbness in hands or feet?",
    "Do you have high blood sugar levels?",
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back to Home"),
            ),
          ],
        );
      },
    );
  }

  String _getDiagnosisMessage(double probability) {
    if (probability >= 70) {
      return "High risk of diabetes. Please consult a doctor.";
    } else if (probability >= 40) {
      return "Moderate risk. Monitor your symptoms.";
    } else {
      return "Low risk. Keep monitoring your health.";
    }
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestionIndex = 0;
      _yesCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 30),
              Image.asset("images/diabet.png", height: 100),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Let's start checking your insulin level by some basic questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _questions[_currentQuestionIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 30),
              _buildAnswerButtons(),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(child: Image.asset("images/img.png", height: 60)),
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
            color:
                _currentQuestionIndex >= index
                    ? _primaryColor
                    : Colors.grey[300],
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
        _buildAnswerButton("Yes", Colors.blue, Colors.white, Icons.check, true),
        const SizedBox(width: 20),
        _buildAnswerButton("No", Colors.red, Colors.white, Icons.close, false),
      ],
    );
  }

  Widget _buildAnswerButton(
    String text,
    Color bgColor,
    Color textColor,
    IconData icon,
    bool isYes,
  ) {
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
