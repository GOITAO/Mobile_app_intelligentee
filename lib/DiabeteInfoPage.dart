import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:app/QuestionnaireDiabeteApp.dart';
import 'package:app/Home.dart';
import 'package:app/ProfilePage.dart';
import 'package:app/HistoryPage.dart';

class DiabeteInfoPage extends StatefulWidget {
  const DiabeteInfoPage({super.key});

  @override
  State<DiabeteInfoPage> createState() => _DiabeteInfoPageState();
}

class _DiabeteInfoPageState extends State<DiabeteInfoPage> with SingleTickerProviderStateMixin {
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
    const Color primaryColor = Color.fromARGB(255, 35, 111, 252);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Health'),
        backgroundColor: primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen(username: 'User')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage(condition: 'all')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(username: 'User', email: 'yasstaoufiq@example.com'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset('images/diabet.png', height: 160),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Understanding Diabetes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Diabetes affects how your body processes blood sugar. Type 1 and Type 2 diabetes require management to avoid complications.",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuestionnaireDiabeteApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Questionnaire"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add AI Form for Diabetes when available
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
