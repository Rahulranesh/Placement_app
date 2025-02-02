import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class AdminUploadExamsScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadExamsScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadExamsScreenState createState() => _AdminUploadExamsScreenState();
}

class _AdminUploadExamsScreenState extends State<AdminUploadExamsScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String date = '';

  /// Uploads the exam after validating the form.
  Future<void> _uploadExam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Call addExam() without the department parameter,
        // as the DatabaseService now fetches the department internally.
        await DatabaseService().addExam(
          examData: {
            'title': title,
            'date': date,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exam uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading exam: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      // Upload mode: show the form to add a new exam.
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Exam')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Exam Title'),
                  onSaved: (value) => title = value!.trim(),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter exam title'
                      : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Exam Date (YYYY-MM-DD)'),
                  onSaved: (value) => date = value!.trim(),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter exam date'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadExam,
                  child: const Text('Upload Exam'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Display mode: fetch and display the list of exams.
      return Scaffold(
        appBar: AppBar(title: const Text('Exams')),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getExams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching exams data: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No exams found.'));
            }
            final exams = snapshot.data!;
            return ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                var exam = exams[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(exam['title'] ?? ''),
                    subtitle: Text('Date: ${exam['date'] ?? ''}'),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
