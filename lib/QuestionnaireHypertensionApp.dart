import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:app/Home.dart';
import 'package:app/ProfilePage.dart';
import 'package:app/HistoryPage.dart';

class QuestionnaireHypertensionApp extends StatelessWidget {
  const QuestionnaireHypertensionApp({super.key});

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

  final Color _primaryColor = Colors.purple;

  final List<String> _questions = [
    "Do you often have headaches?",
    "Do you feel dizziness or fainting spells?",
    "Do you experience nosebleeds frequently?",
    "Do you often feel shortness of breath?",
    "Do you have blurred vision sometimes?",
    "Do you feel chest pain occasionally?",
    "Do you notice irregular heartbeats?",
    "Do you feel tired easily?",
    "Do you have trouble sleeping at night?",
    "Do you experience confusion or memory problems?",
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
                // TODO: Implement IA Diagnostic Form for Hypertension
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
    if (probability >= 70) return "High risk of hypertension. Please consult a doctor.";
    if (probability >= 40) return "Moderate risk. Monitor your blood pressure regularly.";
    return "Low risk. Keep maintaining a healthy lifestyle.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hypertension Questionnaire'),
        backgroundColor: _primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
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
              child: Image.asset("images/hypertention.png", height: 140),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Let's check your risk of hypertension",
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
        _buildAnswerButton("Yes", Colors.purple, Colors.white, Icons.check, true),
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
          color: Colors.purple,
          iconSize: 32,
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: _nextQuestion,
          icon: const Icon(Icons.arrow_forward_ios),
          color: Colors.purple,
          iconSize: 32,
        ),
      ],
    );
  }
}
