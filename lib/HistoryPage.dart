import 'package:flutter/material.dart';
import 'package:app/Home.dart';
import 'package:app/ProfilePage.dart';

class HistoryPage extends StatelessWidget {
  final String condition;

  const HistoryPage({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> allHistory = {
      'Heart': [
        {"date": "2024-03-01", "status": "Normal"},
        {"date": "2024-04-01", "status": "High Risk"},
      ],
      'Kidney': [
        {"date": "2024-03-10", "status": "Moderate Risk"},
      ],
      'Insulin': [
        {"date": "2024-03-15", "status": "High Risk"},
      ],
      'Hypertension': [
        {"date": "2024-03-18", "status": "Normal"},
      ],
      'Stroke': [
        {"date": "2024-03-20", "status": "Moderate Risk"},
      ],
      'Skin': [
        {"date": "2024-03-25", "status": "Pending"},
      ],
    };

    final bool showAll = condition == 'all';

    return Scaffold(
      appBar: AppBar(
        title: Text(showAll ? 'Health Monitor' : '$condition History'),
        backgroundColor: const Color.fromARGB(255, 35, 111, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showAll
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Health Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: allHistory.entries.map((entry) {
                        final name = entry.key;
                        final latest = entry.value.last;
                        return ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.blue),
                          title: Text("$name Test"),
                          subtitle: Text("Status: ${latest["status"]}"),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistoryPage(condition: name),
                                ),
                              );
                            },
                            child: const Text("See History"),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              )
            : ListView(
                children: allHistory[condition]!
                    .map((entry) => ListTile(
                          leading: const Icon(Icons.history),
                          title: Text("${entry['date']}: ${entry['status']}"),
                        ))
                    .toList(),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 35, 111, 252),
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
    );
  }
}
