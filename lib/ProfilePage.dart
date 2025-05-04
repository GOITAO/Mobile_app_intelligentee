import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:app/HistoryPage.dart';
import 'package:app/Login.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;

  const ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  int _selectedIndex = 2;
  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _email = widget.email;
    _loadProfile();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', pickedFile.path);
    }
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    final name = prefs.getString('username');
    final email = prefs.getString('email');
    setState(() {
      if (path != null) _profileImage = File(path);
      if (name != null) _username = name;
      if (email != null) _email = email;
    });
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(text: _username);
    TextEditingController emailController = TextEditingController(text: _email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('username', nameController.text);
              await prefs.setString('email', emailController.text);
              setState(() {
                _username = nameController.text;
                _email = emailController.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated.")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> testResults = {
      "Heart": "Normal",
      "Kidney": "Monitor",
      "Insulin": "High Risk",
      "Hypertension": "Normal",
      "Stroke": "Moderate Risk",
      "Skin": "Pending",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 35, 111, 252),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightBlueAccent,
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                  ),
                  const SizedBox(height: 10),
                  Text(_username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(_email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showEditDialog,
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text("Add Photo"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Health Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...testResults.entries.map((e) => ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.blue),
                  title: Text("${e.key} Test"),
                  subtitle: Text("Status: ${e.value}"),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HistoryPage(condition: e.key)),
                      );
                    },
                    child: const Text("See History"),
                  ),
                )),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0 || index == 1) {
            Navigator.pop(context);
          }
        },
        iconSize: 32,
        selectedItemColor: const Color.fromARGB(255, 35, 111, 252),
        unselectedItemColor: const Color.fromARGB(255, 217, 215, 215),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
