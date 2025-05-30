import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:app/Home.dart';
import 'package:app/ProfilePage.dart';
import 'package:app/HistoryPage.dart';

class QuestionnaireDiabeteApp extends StatelessWidget {
  const QuestionnaireDiabeteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QuestionnaireScreen(),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _yesCount = 0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final Color _primaryColor = Colors.green;

  final List<String> _questions = [
    "Do you frequently feel thirsty?",
    "Do you often urinate?",
    "Do you feel extreme fatigue?",
    "Do you have blurry vision?",
    "Have you noticed weight loss recently?",
    "Do you feel hungrier than usual?",
    "Do your wounds heal slowly?",
    "Do you feel numbness or tingling in feet/hands?",
    "Do you often feel irritable or moody?",
    "Do you have dry skin?",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showResultDialog();
      }
    });
  }

  void _prevQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        if (_yesCount > 0) _yesCount--;
      }
    });
  }

  void _answer(bool isYes) {
    if (isYes) _yesCount++;
    _nextQuestion();
  }

  void _showResultDialog() {
    double probability = (_yesCount / _questions.length) * 100;

    if (probability >= 70) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("⚠️ High Risk Detected"),
          content: const Text("We recommend consulting a doctor or using the AI diagnostic form."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay")),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen(username: 'User')),
              ),
              child: const Text("Back to Home"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement IA Diagnostic Form for diabetes
              },
              child: const Text("Go to AI Form"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Result"),
          content: Text(_getDiagnosisMessage(probability)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }

  String _getDiagnosisMessage(double probability) {
    if (probability >= 70) return "High risk of diabetes. Please consult your doctor.";
    if (probability >= 40) return "Moderate risk. Keep monitoring your symptoms.";
    return "Low risk. Maintain a healthy lifestyle.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Questionnaire'),
        backgroundColor: _primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen(username: 'User')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage(condition: 'all')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(username: 'User', email: 'yasstaoufiq@example.com'),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            _buildProgressIndicator(),
            const SizedBox(height: 30),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset("images/diabet.png", height: 140),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Let's check your risk of diabetes",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Question ${_currentQuestionIndex + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                _questions[_currentQuestionIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            _buildAnswerButtons(),
            const SizedBox(height: 30),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_questions.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
        _buildAnswerButton("Yes", Colors.green, Colors.white, Icons.check, true),
        const SizedBox(width: 20),
        _buildAnswerButton("No", Colors.grey, Colors.white, Icons.close, false),
      ],
    );
  }

  Widget _buildAnswerButton(String text, Color bgColor, Color textColor, IconData icon, bool isYes) {
    return ElevatedButton.icon(
      onPressed: () => _answer(isYes),
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _prevQuestion,
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.green,
          iconSize: 32,
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: _nextQuestion,
          icon: const Icon(Icons.arrow_forward_ios),
          color: Colors.green,
          iconSize: 32,
        ),
      ],
    );
  }
}
