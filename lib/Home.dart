import 'package:flutter/material.dart';
import 'package:app/MaladiesInfantilesApp.dart';
import 'package:app/HeartHealthApp.dart';
import 'package:app/QuestionnaireDiabeteApp.dart';
import 'package:app/QuestionnaireHeartApp.dart';
import 'package:app/QuestionnaireKidneyApp.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HealthIcon> _healthIcons = [
    HealthIcon(imagePath: 'images/heart.png', label: 'Heart'),
    HealthIcon(imagePath: 'images/kidney.png', label: 'Kidney'),
    HealthIcon(imagePath: 'images/diabet.png', label: 'Insulin'),
  ];

  final List<Widget> pages = [
    HeartHealthApp(),
    QuestionnaireKidneyApp(),
  HeartHealthApp(),
  ];

  final Color _primaryColor = const Color.fromARGB(255, 35, 111, 252);
  final Color _secondaryColor = const Color.fromARGB(255, 19, 237, 154);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitor', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How Are You\nFeeling Today?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: _buildActionCard('Checkup', Icons.medical_services)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildActionCard('Cashuit', Icons.wallet)),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Your condition',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, color: Colors.white),
                label: Text('+Health', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _secondaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: _healthIcons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final icon = entry.value;
                  return _buildHealthIcon(icon, pages[index]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedItemColor: _primaryColor,
        unselectedItemColor: const Color.fromARGB(255, 217, 215, 215),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHealthIcon(HealthIcon healthIcon, Widget targetPage) {
    return GestureDetector(
      onTap: () => setState(() => healthIcon.isSelected = !healthIcon.isSelected),
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: ClipRRect(
                key: ValueKey<bool>(healthIcon.isSelected),
                borderRadius: BorderRadius.circular(20),
                child: ColorFiltered(
                  colorFilter: healthIcon.isSelected
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: Image.asset(
                    healthIcon.imagePath,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (healthIcon.isSelected)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => targetPage,
                            ),
                          );
                        },
                        child: Text(
                          'My ${healthIcon.label}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_forward,
                          color: _secondaryColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: _primaryColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class HealthIcon {
  final String imagePath;
  final String label;
  bool isSelected;

  HealthIcon({
    required this.imagePath,
    required this.label,
    this.isSelected = false,
  });
}
