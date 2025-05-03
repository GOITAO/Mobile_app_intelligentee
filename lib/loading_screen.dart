import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:app/Login.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 300), _simulateLoading);
  }

  void _simulateLoading() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => progressValue += 0.02);
      if (progressValue < 1.0) {
        _simulateLoading();
      } else {
        _goToLoginWithFade();
      }
    });
  }

  void _goToLoginWithFade() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, animation, __) => const Login(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset('images/img.png', height: 160),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  "Health Monitoring & Assistance",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 35, 111, 252),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: const Color.fromARGB(255, 35, 111, 252),
                  backgroundColor: Colors.blue[100],
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
