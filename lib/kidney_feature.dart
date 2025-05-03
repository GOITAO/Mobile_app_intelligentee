import 'package:flutter/material.dart';

class KidneyResultPage extends StatefulWidget {
  final double probability;
  final String message;

  const KidneyResultPage({required this.probability, required this.message});

  @override
  _KidneyResultPageState createState() => _KidneyResultPageState();
}

class _KidneyResultPageState extends State<KidneyResultPage> {
  late TextEditingController probabilityController;
  late TextEditingController messageController;

  String analysisResult = '';

  @override
  void initState() {
    super.initState();
    probabilityController =
        TextEditingController(text: "${widget.probability.toStringAsFixed(1)}%");
    messageController = TextEditingController(text: widget.message);
  }

  @override
  void dispose() {
    probabilityController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _analyze() {
    setState(() {
      if (widget.probability >= 80) {
        analysisResult = "Very High Risk – Immediate attention required.";
      } else if (widget.probability >= 50) {
        analysisResult = "Moderate Risk – Consider seeing a specialist.";
      } else {
        analysisResult = "Low Risk – Maintain a healthy lifestyle.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed Result"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Kidney Risk Assessment",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Risk probability
            TextFormField(
              controller: probabilityController,
              decoration: const InputDecoration(
                labelText: "Risk Level",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Message
            TextFormField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Analyze Button
            ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.analytics),
              label: const Text("Analyser"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Display result
            if (analysisResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        analysisResult,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
