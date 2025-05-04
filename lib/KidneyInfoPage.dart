import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:app/QuestionnaireKidneyApp.dart';
import 'package:app/Home.dart';
import 'package:app/ProfilePage.dart';
import 'package:app/HistoryPage.dart';

class KidneyInfoPage extends StatefulWidget {
  const KidneyInfoPage({super.key});

  @override
  State<KidneyInfoPage> createState() => _KidneyInfoPageState();
}

class _KidneyInfoPageState extends State<KidneyInfoPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool showOptions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kidney Health'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen(username: 'User')),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilePage(username: 'User', email: 'yasstaoufiq@example.com'),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'images/kidney.png',
                  height: 160,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Understanding Kidney Conditions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kidney disease affects your body’s ability to clean your blood, control blood pressure, and perform other functions. Early testing can save lives.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            const Text(
              "How would you like to get diagnosed?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Chat with Assistant"),
              onPressed: () {
                // TODO: Navigate to chatbot
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.analytics_outlined),
              label: const Text("Use AI Diagnostic Form"),
              onPressed: () {
                setState(() {
                  showOptions = !showOptions;
                });
              },
            ),
            const SizedBox(height: 20),
            if (showOptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionnaireKidneyApp()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Questionnaire"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Go to KidneyFormPage (when created)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Formulaire IA"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}