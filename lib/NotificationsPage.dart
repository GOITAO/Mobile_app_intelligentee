import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'Heart Risk',
        'body': 'Your last result was borderline. Retest soon.',
        'icon': '❤️',
      },
      {
        'title': 'Insulin Alert',
        'body': 'High insulin detected. Please take action.',
        'icon': '💉',
      },
      {
        'title': 'Retest Reminder',
        'body': 'You haven’t tested your kidney health this week.',
        'icon': '🩺',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color.fromARGB(255, 35, 111, 252),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: Text(notif['icon']!, style: const TextStyle(fontSize: 24)),
            title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notif['body']!),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
