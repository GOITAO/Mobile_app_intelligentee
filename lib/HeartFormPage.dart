import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartFormPage extends StatefulWidget {
  const HeartFormPage({super.key});

  @override
  State<HeartFormPage> createState() => _HeartFormPageState();
}

class _HeartFormPageState extends State<HeartFormPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {
    "age": '',
    "sex": '',
    "cp": '',
    "trestbps": '',
    "chol": '',
    "fbs": '',
    "restecg": '',
    "thalach": '',
    "exang": '',
    "oldpeak": '',
    "slope": '',
    "ca": '',
    "thal": ''
  };

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Processing...")),
      );

      try {
        final url = Uri.parse('http://127.0.0.1:5000/predict-heart');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formData),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final prediction = result['result'];
          final proba = (result['probability'][prediction] * 100).toStringAsFixed(1);

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Prediction Result"),
              content: Text(
                prediction == 1
                    ? "⚠️ Heart Disease Detected\nConfidence: $proba%"
                    : "✅ No Heart Disease Detected\nConfidence: $proba%",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            ),
          );
        } else {
          throw Exception('Prediction failed: ${response.body}');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: TextInputType.number,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        onSaved: (value) => formData[key] = num.tryParse(value ?? '') ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heart Diagnostic Form"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Please complete the following fields for AI analysis",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField("age", "Age"),
              _buildTextField("sex", "Sex (1=Male, 0=Female)"),
              _buildTextField("cp", "Chest Pain Type (0-3)"),
              _buildTextField("trestbps", "Resting Blood Pressure"),
              _buildTextField("chol", "Serum Cholestoral (mg/dl)"),
              _buildTextField("fbs", "Fasting Blood Sugar > 120 mg/dl (1 = true; 0 = false)"),
              _buildTextField("restecg", "Resting Electrocardiographic Results (0-2)"),
              _buildTextField("thalach", "Maximum Heart Rate Achieved"),
              _buildTextField("exang", "Exercise Induced Angina (1 = yes; 0 = no)"),
              _buildTextField("oldpeak", "ST depression induced by exercise"),
              _buildTextField("slope", "Slope of the peak exercise ST segment (0-2)"),
              _buildTextField("ca", "Number of major vessels (0-3)"),
              _buildTextField("thal", "Thalassemia (1 = normal; 2 = fixed defect; 3 = reversable defect)"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Submit & Predict"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
